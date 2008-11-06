<?php
class UsersRoles extends Zend_Db_Table{
    protected $_name            = 'users_roles';
    protected $_referenceMap    = array(
        '' => array(
            'columns'           => array('user'),
            'refTableClass'     => 'Users',
            'refColumns'        => array('id')
            )
            );
}
?>