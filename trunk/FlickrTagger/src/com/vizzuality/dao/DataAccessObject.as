package com.vizzuality.dao
{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
		
	public class DataAccessObject {
		
		private var sentence:String="";
		private var providedSqlStatement:SQLStatement;
		private var dbFile:File = File.applicationStorageDirectory.resolvePath("DBV.db");
		private var sqlConect:SQLConnection;
		private var sqlStatement: SQLStatement;
		private var result:ArrayCollection;
		
		
		public function get dbResult():ArrayCollection {
	    	return result;
		}


		public function set dbResult(value:ArrayCollection):void {
	    	result = value;
		}
	 
	
		public function DataAccessObject() {}
		

		public function openConnection(str:String,_providedSqlStatement:SQLStatement=null):void {
		    sentence = str;
			this.providedSqlStatement = _providedSqlStatement;
		    sqlConect = new SQLConnection();
		    sqlConect.addEventListener(SQLEvent.OPEN, sqlConnectionOpenHandler);
		    sqlConect.addEventListener(SQLErrorEvent.ERROR, sqlConnectionErrorHandler);
		    sqlConect.open(dbFile);		
		}
		
		
		
		private function sqlConnectionOpenHandler(ev:SQLEvent):void {
			if(providedSqlStatement) {
				sqlStatement = providedSqlStatement;
			} else {
				sqlStatement = new SQLStatement();
				sqlStatement.text = sentence;
			}
			sqlStatement.sqlConnection = sqlConect;
			sqlStatement.addEventListener(SQLEvent.RESULT, handlerStatement);
			sqlStatement.addEventListener(SQLErrorEvent.ERROR, sqlConnectionErrorHandler);
			sqlStatement.execute();
		}
				
		
		
		private function sqlConnectionErrorHandler(ev:SQLErrorEvent):void {
			Alert.show("Error: " +  ev.error.message);
		}	
		
				
		private function handlerStatement(ev:SQLEvent):void {
			var result:SQLResult = sqlStatement.getResult();
			dbResult = new ArrayCollection(result.data);
		}
		
		
		public function createTables():void {
			var sqlCreate1:String = 
		    "CREATE TABLE IF NOT EXISTS user (" + 
		    "    alias TEXT PRIMARY KEY, " + 
		    "    token TEXT" +
		    ")";
			openConnection(sqlCreate1);
			
			var sqlCreate2:String =
			"CREATE TABLE IF NOT EXISTS photos (" +
			"id INTEGER PRIMARY KEY AUTOINCREMENT,"+
			"path TEXT," +
			"scientific TEXT DEFAULT NULL,"+
			"lat TEXT," +
			"lon TEXT," +
			"group_id INTEGER DEFAULT NULL," + 
			"timestamp DATETIME)";
			openConnection(sqlCreate2);	
			
			
			var sqlCreate3:String =
			"CREATE TABLE IF NOT EXISTS groups (" +
			"id INTEGER PRIMARY KEY AUTOINCREMENT,"+
			"path TEXT," +
			"scientific TEXT DEFAULT NULL,"+
			"lat TEXT," +
			"lon TEXT,"+
			"timestamp DATETIME)";
			openConnection(sqlCreate3);	
					
		}
		
		
		public function getLatitudes(path:String):void {
			var sqlSentence: String = "SELECT lat,lon,zoom FROM photos WHERE path='"+path+"'";
			openConnection(sqlSentence);
		}
		
		
		public function updatePosition(lat:String,lon:String,zoom:int,path:String):void {
			var sqlSentence: String = "UPDATE photos SET lat = '"+lat+"', lon = '"+lon+"', zoom = '"+zoom+"' WHERE path = '"+path+"'";
			openConnection(sqlSentence);
		}
		
		
		public function getTaxonomy(path:String):void {
			var sqlSentence: String = "SELECT kingdom,phylum,clas,orde,family,genus,binomial FROM photos WHERE path='"+path+"'";
			openConnection(sqlSentence);
		}
		
	
		public function countHandler(sqlArray: ArrayCollection):int {
			var numRows:int = sqlArray.length;
			var count: int;
			for (var i:int = 0; i < numRows; i++) {
		        var output:String = "";
		        for (var columnName:String in sqlArray[i]) {
		            count=sqlArray[i][columnName];
		        }
		    }	
		    return count;
	    }
	    
		
		
		public function showTable(result: ArrayCollection):void {
			if (result.length!=0) {
				var numRows:int = result.length;
			    for (var i:int = 0; i < numRows; i++) {
			        var output:String = "";
			        for (var columnName:String in result[i]) {
			            output += columnName + ": " + result[i][columnName] + "; ";
			        }
			        trace("row[" + i.toString() + "]\t", output);
			    }
		    }
		}

	}
}