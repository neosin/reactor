<?php
require_once 'models/Object.php';

class Objects extends Zend_Db_Table{
	protected $_name            = 'site_objects';
	protected $_rowClass        = 'Object';

	/**
	 * fetches the full tree from db
	 * @return Zend_Db_Table_Rowset
	 */
	public function fetchFullTree(){
		$select = $this->select()
		->from(array('o'=>$this->_name),
		array('id','title','lft','rgt',new Zend_Db_Expr('(COUNT(p.id) - 1) AS depth'))
		)
		->join(array('p'=>$this->_name),null,array())
		->where('p.id',1)
		->where(new Zend_db_Expr('o.lft BETWEEN p.lft AND p.rgt'))
		->group('o.id')
		->order('o.lft');
		return $this->fetchAll($select);
	}
	/**
	 * fetches the path to node
	 * @param $id integer
	 * @return Zend_Db_Table_Rowset
	 */
	public function fetchPathToNode($id){
		$select = $this->select()
		->from(array('o'=>$this->_name),
		array()
		)
		->join(array('p'=>$this->_name),null,
		array('id','title','lft','rgt'))
		->where('o.id = ?',(int)$id)
		->where(new Zend_db_Expr('o.lft BETWEEN p.lft AND p.rgt'))
		->order('p.lft');
		return $this->fetchAll($select);
	}
	/**
	 * fetches subtree starting from element id
	 * @param $id integer Root of tree
	 * @return Zend_Db_Table_Rowset
	 */
	public function fetchSubTree($id){
		$subselect = $this->select()
		->from(array('o'=>$this->_name),
		array('id',new Zend_Db_Expr('(COUNT(p.id) - 1) AS depth'))
		)
		->join(array('p'=>$this->_name),null,array())
		->where('o.id = ?',(int)$id)
		->where(new Zend_db_Expr('o.lft BETWEEN p.lft AND p.rgt'))
		->group('o.id')
		->order('o.lft');
		$select = $this->select()
		->from(array('o'=>$this->_name),
		array('id','title','lft','rgt',new Zend_Db_Expr('(COUNT(p.id) - (st.depth + 1)) AS depth'))
		)
		->join(array('p'=>$this->_name),null,array())
		->join(array('sp'=>$this->_name),null,array())
		->join(array('st'=> $subselect),null,array())
		->where('sp.id = st.id')
		->where(new Zend_db_Expr('o.lft BETWEEN p.lft AND p.rgt'))
		->where(new Zend_db_Expr('o.lft BETWEEN sp.lft AND sp.rgt'))
		->group('o.id')
		->order('p.lft');
		return $this->fetchAll($select);
	}

	public function fetchDirectChildren($id){
		$subselect = $this->select()
		->from(array('o'=>$this->_name),
		array('id',new Zend_Db_Expr('(COUNT(p.id) - 1) AS depth'))
		)
		->join(array('p'=>$this->_name),null,array())
		->where('o.id = ?',(int)$id)
		->where(new Zend_db_Expr('o.lft BETWEEN p.lft AND p.rgt'))
		->group('o.id')
		->order('o.lft');
		$select = $this->select()
		->from(array('o'=>$this->_name),
		array('id','title','lft','rgt',new Zend_Db_Expr('(COUNT(p.id) - (st.depth + 1)) AS depth'))
		)
		->join(array('p'=>$this->_name),null,array())
		->join(array('sp'=>$this->_name),null,array())
		->join(array('st'=> $subselect),null,array())
		->where('sp.id = st.id')
		->where(new Zend_db_Expr('o.lft BETWEEN p.lft AND p.rgt'))
		->where(new Zend_db_Expr('o.lft BETWEEN sp.lft AND sp.rgt'))
		->group('o.id')
		->having('depth = 1')
		->order('p.lft');
		return $this->fetchAll($select);
	}

	public function createRowAfterNode($id ,array $data = array()){
		$this->getAdapter()->query('LOCK TABLES');
		$this->getAdapter()->beginTransaction();
		try{
			$select = $this->select()->from($this->_name,array('rgt'))->where('id = ?',(int)$id);
			$rgtRow = $this->fetchRow($select);
			if($rgtRow){
				$this->update(array('rgt' => new Zend_Db_Expr('rgt + 2')), array('rgt > '. $rgtRow->rgt ));
				$this->update(array('lft' => new Zend_Db_Expr('lft + 2')),  array('lft > '. $rgtRow->rgt ));
			}
			$row = $this->createRow($data);
			$row->lft = $rgtRow->rgt +1;
			$row->rgt = $rgtRow->rgt +2;
			$row->save();
			$this->getAdapter()->commit();
		}
		catch(Exception $e){
			Zend_Debug::dump($e->getMessage());
			$this->getAdapter()->rollBack();
				
		}
		$this->getAdapter()->query('UNLOCK TABLES');
	}
	public function createRowAsFirstChild($id,array $data = array()){
		$this->getAdapter()->query('LOCK TABLES');
		$this->getAdapter()->beginTransaction();
		try{
			if($this->fetchDirectChildren($id)->count() > 0){
				require_once 'Zend/Db/Table/Exception.php';
				throw new Zend_Db_Table_Exception('This node has children please use createRowAfterNode()');
			}
			else{
				$select = $this->select()->from($this->_name,array('lft'))->where('id = ?',(int)$id);
				$lftRow = $this->fetchRow($select);
				if($lftRow){
					$this->update(array('rgt' => new Zend_Db_Expr('rgt + 2')),array('rgt > '. $lftRow->lft ));
					$this->update(array('lft' => new Zend_Db_Expr('lft + 2')),array('lft > '. $lftRow->lft ));
				}
				$row = $this->createRow($data);
				$row->lft = $lftRow->lft +1;
				$row->rgt = $lftRow->lft +2;
				$row->save();
				$this->getAdapter()->commit();
			}
		}
		catch(Exception $e){
			$this->getAdapter()->rollBack();
		}
		$this->getAdapter()->query('UNLOCK TABLES');
	}
}
?>