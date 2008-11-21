<?php
class Reactor_Role extends Zend_Db_Table_Row{
    private static $_rolesTable;
    private static $_aclTable;

    public static function getRolesTable(){
        if(empty(self::$_rolesTable)){
            self::$_rolesTable = new Reactor_Db_Table(array(
            'name'=>'roles',
            'rowClass'=>'Reactor_Role'
            ));
        }
        return self::$_rolesTable;
    }

    public static function getAclTable(){
        if(empty(self::$_aclTable)){
            self::$_aclTable = new Reactor_Db_Table(array(
            'name'=>'acl'
            ));
        }
        return self::$_aclTable;
    }
    /*
     * Used to create a new role
     * @param $id integer
     * @return Role
     */
    public static function factory($id){
        $row = self::getRolesTable()->find((int)$id);
        if($row->count()){
            return $row->current();
        }
        else{
            throw new Zend_Exception('Role does not exist');
        }
    }

    /**
     * returns role list
     * @return rowset
     */
    public static function fetchAllRoles(){
        $roles = self::getRolesTable()->fetchAll(
        self::getRolesTable()->select()->order('name','ASC'));
        return $roles;
    }
    /*
     * return form object "create"
     * @return form
     */
    public static function getFormCreate(){
        require_once 'forms/Role/Create.php';
        $form = new Reactor_Form_Role_Create;
        return $form;
    }
    /*
     * return form object "update"
     * @return form
     */
    public function getFormUpdate(){
        $form =$this->getFormCreate();
        $form->addElement('hidden','role',array(
        'validators'=>array('Int'=>array(
        'validator'=>'Int',
        )),
        'required'=>'true',
        'value'=>$this->id
        ));
        $form->getElement('submit')->setLabel('f_updateRole');
        $form->populate($this->toArray());
        return $form;
    }
    /*
     * creates new role
     * @param $data
     * @return row
     */
    public static function create($data){
        $insertData = array(
        'name'=> $data['name'],
        'description'=> $data['description']
        );
        $newRow = self::getRolesTable()->createRow();
        $newRow->setFromArray($insertData);
        return $newRow->save();
    }
    /*
     * updates role
     * @param $data
     * @return row
     */
    public function update($data){
        $updateData = array(
        'name'=> $data['name'],
        'description'=> $data['description']
        );
        $this->setFromArray($updateData);
        return $this->save();
    }
    /*
     * removes role
     * @return nothing
     */
    public function remove(){
        $where = 'id NOT IN (1,2,3) and id = '. $this->id;
        self::getRolesTable()->delete($where);
    }
    /*
     * return form object "remove"
     * @return role
     */
    public function getFormRemove(){
        include_once 'forms/Role/Remove.php';
        $form = new Reactor_Form_Role_Remove;
        return $form;
    }
    /*
     * sets specific admin panel permission
     * @param $data
     * @return self
     */
    public function setAdminPanelPermission($permission){
        $row = self::getAclTable()->fetchRow(self::getAclTable()->select()->where('role = ?',$this->id)->where('permission = ?',(int)$permission));
        if($row){
            return $row->delete();
        }
        else{
            $row = self::getAclTable()->createRow();
            $row->object = 1;
            $row->role = $this->id;
            $row->permission = (int)$data['permission'];
            $row->save();
        }
        return $this;
    }
    /*
     * returns panel permission list
     * @return array
     */
    public function fetchAdminPanelPermissions(){
        $permissions = self::getAclTable()->getAdapter()->fetchCol(
        self::getAclTable()->select()->from('acl','permission')->where('role = ?', $this->id)
        ->where('object = ?',1)
        );
        if($permissions){
            return $permissions;
        }
        return array();
    }
    /*
     * return from used for permission setting
     * @return form
     */
    public function getFormAdminPanelPermissions(){
        include_once 'forms/Role/AdminPanelPermissions.php';
        $form = new Reactor_Form_Role_AdminPanelPermissions;
        return $form;
    }
}
/**
 * permissions
 * 1 - access to admin panel
 * 2 - access to system options/defaults
 * 3 - access to user management
 * 4 - access to e-commerce settings
 * 5 - access to newsletters
 * 6 - access to object management
 * 0 - access only for administrators
 */
?>