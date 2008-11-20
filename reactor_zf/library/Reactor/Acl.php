<?php
/**
 * handles the authentication of users inside database
 * @author ergo
 *
 */
class Reactor_Acl{
    const ACCESS_ADMIN_ONLY = 1;
    const ACCESS_ADMIN_SECTION = 5;
    const ACCESS_ADMIN_OPTIONS_PANEL = 10;
    const ACCESS_ADMIN_USERS_PANEL = 15;
    const ACCESS_ADMIN_ROLES_PANEL = 20;
    const ACCESS_ADMIN_ECOMMERCE_PANEL = 25;
    const ACCESS_ADMIN_NEWSLETTER_PANEL = 30;
    const ACCESS_ADMIN_OBJECT_MANAGEMENT_PANEL = 35;
    const ACCESS_OBJECT_BROWSE = 100;
    const ACCESS_OBJECT_READ = 125;
    const ACCESS_OBJECT_UPDATE = 150;
    const ACCESS_OBJECT_REMOVING = 175;
    const ACCESS_OBJECT_MODERATE = 200;
    const ACCESS_OBJECT_SET_PERMISSIONS = 225;
    const ACCESS_CREATE_OBJECT_DOCUMENT = 250;
    const ACCESS_CREATE_OBJECT_DOCUMENT_AGGREGATOR = 275;
    const ACCESS_CREATE_OBJECT_FORUM = 300;
    const ACCESS_CREATE_OBJECT_FORUM_AGGREGATOR = 325;
    const ACCESS_CREATE_OBJECT_ECOMMERCE = 350;
    const ACCESS_CREATE_OBJECT_ECOMMERCE_AGGREGATOR = 375;
    const ACCESS_CREATE_OBJECT_GALLERY = 400;
    const ACCESS_CREATE_OBJECT_GALLERY_AGGREGATOR = 425;
    public static $_aclTable;
    /**
     * returns ACL table model
     * @return Reactor_Db_Table
     */
    public static function getAclTable(){
        if(!(self::$_aclTable instanceof Reactor_Db_Table)){
            self::$_aclTable = new Reactor_Db_Table(array(
            'name'=>'acl'
            ));
        }
        return self::$_aclTable;
    }
    
    /**
     * check if specific roles are allowed to perform specific action on resource
     * @param $roles (array)roles array
     * @param $permissionName (integer)permission identifier 
     * @param $object (integer)object identifier
     * @param $defaultDeniedMessage (boolean)should add a default access denied message to flash messanger
     * @return boolean
     */
    static function isAllowed($roles,$permissionName,$object = null, $defaultDeniedMessage = true){
        $cache = Zend_Registry::get('cache_files');
        $acl = new Zend_Acl();
        #adding all the roles that user has
        $tmpRoles = array();
        foreach($roles as $role){
            $acl->addRole(new Zend_Acl_Role($role->id));
            array_push($tmpRoles,$role->id);
        };
        $select = self::getAclTable()->select()->where('role IN (?)',$tmpRoles);
        #fetching permissions for specific object from database
        #if no object is passed then we test for object 1 - faking site "section" permission
        if(!$object){
            $object = 1;
        }
        $select->where('object = ?',(int)$object);
        #resource for test
        $acl->add(new Zend_Acl_Resource($object));
        #caching
        $permsAvailable = $cache->load(md5(UNIQUE_HASH.$select->__toString()));
        if($permsAvailable === false) {
            $permsAvailable = array();
            #TODO is there a more efficient way to do it instead of casting to array and then casting to object ?
            $aclResources = self::getAclTable()->fetchAll($select)->toArray();
            foreach($aclResources as $aclResource){
                array_push($permsAvailable, (object)$aclResource);
            }
            $cache->save($permsAvailable, md5(UNIQUE_HASH.$select->__toString()), array('acl','user_data'));
        }
        #setting up permissions for roles
        if($permsAvailable){
            foreach($permsAvailable as $perm){
                $acl->allow($perm->role, $perm->object, $perm->permission);
            }
        }
        #admin has access to everything
        #admin group has id of 2 in db
        if(in_array(2,$tmpRoles)){
            $acl->allow(2);
        }
        #setting a role that will be used for testing and will inherit all the priviledges from parent roles
        $acl->addRole(new Zend_Acl_Role('testedRole'),$tmpRoles);
        #query acl
        $result = $acl->isAllowed('testedRole', $object, $permissionName);
        if(!$result && $defaultDeniedMessage){
            $messages = Zend_Controller_Action_HelperBroker::getStaticHelper('Messages');
            $messages->errors = 'e_permission_too_low';
        }
        return $result;
    }
}
?>