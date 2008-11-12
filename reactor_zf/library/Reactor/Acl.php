<?php
/**
 * permissions
 */

$permissions = array(
  'adminPanel'=> 1,
  'optionsManagement'=> 2,
  'userManagement'=> 3,
  'roleManagement'=> 4,
  'ecommerceManagement'=> 5,
  'profileFieldsManagement'=> 6,
  'newsletterManagement'=> 7,
  'objectManagement'=> 8,
  'browsingObjects'=> 100,
  'readingObjects'=> 101,
  'updatingObjects'=> 102,
  'removingObjects'=> 103,
  'moderatingObjects'=> 104,
  'setPermissionsToObject'=> 105,
  'createObjectDocument'=> 150,
  'createObjectDocumentAggregator'=> 175,
  'createObjectForum'=> 200,
  'createObjectForumsAggregator'=> 225,
  'createObjectShopCategory'=> 250,
  'createObjectShopCategoriesAggregator'=> 275,
  'createObjectGallery'=> 300,
  'createObjectGalleryAggregator'=> 325
);
Zend_Registry::set('acl_permissions',$permissions);

class Reactor_Acl{
    public static $_aclTable;
    public static function getAclTable(){
        if(!(self::$_aclTable instanceof Reactor_Db_Table)){
            self::$_aclTable = new Reactor_Db_Table(array(
            'name'=>'acl'
            ));
        }
        return self::$_aclTable;
    }

    static function isAllowed($roles,$permissionName,$object = null, $defaultDeniedMessage = true){
        $permissions = Zend_Registry::get('acl_permissions');
        if(isset($permissions[$permissionName])){
            $actionId = $permissions[$permissionName];
        }
        else{
            $actionId = 9999;
        }
        $cache = Zend_Registry::get('cache');
        $acl = new Zend_Acl();
        //adding all the roles that user has
        $tmpRoles = array();
        foreach($roles as $role){
            $acl->addRole(new Zend_Acl_Role($role->role));
            array_push($tmpRoles,$role->role);
        };
        $select = self::getAclTable()->select()->where('role IN (?)',$tmpRoles);
        //fetching permissions for specific object from database
        if(!$object){
            $object = 1;
        }
        $select->where('object = ?',(int)$object);
        //resource for test
        $acl->add(new Zend_Acl_Resource($object));
        $permsAvailable = $cache->load(md5($select->__toString()));
        if($permsAvailable === false) {
            $permsAvailable = array();
            $aclResources = self::getAclTable()->fetchAll($select)->toArray();
            foreach($aclResources as $aclResource){
                array_push($permsAvailable, new Reactor_Default_Model($aclResource));
            }
            $cache->save($permsAvailable, md5($select->__toString()), array('acl'));
        }
        //setting up permissions for roles
        if($permsAvailable){
            foreach($permsAvailable as $perm){
                $acl->allow($perm->role, $perm->object, $perm->permission);
            }
        }
        //admin has access to everything
        if(in_array(2,$tmpRoles)){
            $acl->allow(2);
        }
        //setting a role that will be used for testing and will inherit all the priviledges from parent roles
        $acl->addRole(new Zend_Acl_Role('testedRole'),$tmpRoles);
        //query acl
        $result = $acl->isAllowed('testedRole', $object, $actionId);
        if(!$result && $defaultDeniedMessage){
            $messages = Zend_Controller_Action_HelperBroker::getStaticHelper('Messages');
            $messages->errors = 'e_permission_too_low';
        }
        return $result;
    }
}
?>