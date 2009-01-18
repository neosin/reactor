<?php
class Object extends Zend_Db_Table_Row{

	public function delete(){
		$this->getAdapter()->query('LOCK TABLES');
		$this->getTable()->getAdapter()->beginTransaction();
		try{
			$this->getTable()->delete('lft BETWEEN ' . $this->lft . ' AND '. $this->rgt );
			$this->getTable()->update(array('rgt'=> new Zend_Db_Expr('rgt - '. ($this->rgt - $this->lft + 1))) ,array('rgt > '. $this->rgt ));
			$this->getTable()->update(array('lft'=> new Zend_Db_Expr('lft - '. ($this->rgt - $this->lft + 1))) ,array('lft > '. $this->rgt ));
			$this->getTable()->getAdapter()->commit();
		}
		catch(Exception $e){
			$this->getTable()->getAdapter()->rollBack();
		}
		$this->getAdapter()->query('UNLOCK TABLES');
	}
}
?>