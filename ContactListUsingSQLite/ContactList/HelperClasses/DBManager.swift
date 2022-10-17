

import Foundation
import SQLite3

struct list {
    var id: Int32
    var name: String
    var number: String
    var image: String
}


class DBManager {
    init()
    {
        //auto create database when class open
        db = openDatabase()
        createTable()
    }
    
    var db : OpaquePointer?
    //database name
    let dbPath : String = "Contacs.sqlite"
    
    func openDatabase() -> OpaquePointer?
    {
        let filePath = try!FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(filePath.path, &db) != SQLITE_OK
        {
            print("Can not be ope database")
            return nil
        }
        else
        {
            print("Open Database successfully")
            print(" file path:--  \(filePath.path)")
            return db
        }
   
    }
    
    func createTable()
    {
        //working...
        // CREATE TABLE IF NOT EXISTS person(id Int NOT NULL AUTO_INCREMENT,name TEXT,age INTEGER,PRIMARY KEY (id));
        //table name ContactList
        let createTableString = "CREATE TABLE IF NOT EXISTS ContactList(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT NOT NULL,number TEXT NOT NULL,image TEXT NOT NULL);"
        var createTableStatement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("personal Table created")
            }
            else
            {
                print("Table is not created")
            }
            
        }
        else
        {
            print("create table statement no be preaped")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    
    func insert(name : String , number : String ,image:String)
    {
        
        let insertStatementString = """
        INSERT INTO ContactList (
        name,
        number,
        image
        )
        VALUES ('\(name as String)','\(number as String)','\(image as String)');
        """
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK
        {
            //sqlite3_bind_text(insertStatement, 1, name as String, -1, nil)
            //sqlite3_bind_text(insertStatement, 2, number as String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_OK
            {
                print("Successfully Inserted \(name) \(number) ")
            }
            else
            {
                print("Not insered")
            }
        }
        else
        {
            print("Insert satatement coud not be prepared")
        }
        //close connection to database
        sqlite3_finalize(insertStatement)
    }
    
    
    func readData() -> [list] {
        let queryStatementString = "SELECT * FROM ContactList;"
                var queryStatement: OpaquePointer? = nil
                var emps : [list] = []
                if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                    
                    //get whole table using while loop
                    while sqlite3_step(queryStatement) == SQLITE_ROW {
                        
                        let id = sqlite3_column_int(queryStatement, 0)
                        let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                        let number = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                        let image = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                        
                        emps.append(list(id: id, name: name, number: number , image:image))
                        print("\(id) | \(name) | \(number)")
                    }
                } else {
                    print("SELECT statement could not be prepared")
                }
                sqlite3_finalize(queryStatement)
                return emps
    }
    
//    not working
    func deleteDatabase(){
        
        let deleteStatement = "DELETE TABLE IF EXISTS ContactList;"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(db, deleteStatement, -1, &queryStatement, nil) == SQLITE_OK {
                    print("Data Deleted Successfully")
                }else{
                    print("Sorry data not Deleted")
                }
        sqlite3_finalize(queryStatement)
        
    }
    
    func deleteIndex(id:Int32) {
          let deleteStatementStirng = "DELETE FROM ContactList WHERE id = ?;"
          var deleteStatement: OpaquePointer? = nil
          if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
              sqlite3_bind_int(deleteStatement, 1, Int32(id))
              if sqlite3_step(deleteStatement) == SQLITE_DONE {
                  print("Successfully deleted row.")
              } else {
                  print("Could not delete row.")
              }
          } else {
              print("DELETE statement could not be prepared")
          }
          sqlite3_finalize(deleteStatement)
      }
    
    
    //edit row with index
    func editIndex(id:Int32, name:String, number:String, image:String) {
        print("Data editing....")
        
        let deleteStatementStirng = "DELETE FROM ContactList WHERE id = ?;"
        let insertStatementString = """
        INSERT INTO ContactList (
        name,
        number,
        image)
        VALUES ('\(name as String)','\(number as String)'),,'\(image as String)');
        """
        var idStatement: OpaquePointer? = nil
        
        //delete that element
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &idStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(idStatement, 1, Int32(id))
            if sqlite3_step(idStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        // add new at same index
//        if sqlite3_prepare_v2(db, insertStatementString, -1, &idStatement, nil) == SQLITE_OK
//        {
            //sqlite3_bind_text(insertStatement, 1, name as String, -1, nil)
            //sqlite3_bind_text(insertStatement, 2, number as String, -1, nil)
            
//            if sqlite3_step(idStatement) == SQLITE_OK
//            {
//                print("Successfully Inserted \(name) \(number)")
//            }
//            else
//            {
//                print("Not insered")
//            }
//        }
//        else
//        {
//            print("Insert satatement coud not be prepared")
//        }
        
        sqlite3_finalize(idStatement)
        insert(name: name, number: number, image: image)
        
    }
}


