import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * 	QuerySelector Selects a query to execute.
 *  @author Almon
 */
public abstract class QuerySelector {
	
	/**
	 * Constructor that uses already established connection to query a database
	 * @param  con  Connector for connecting to a database
	 * @param  query  Query to be executed
	 * @return A AdventureWorks2017Connector type 
	 */
	protected QuerySelector(Connector con, String query) {
		try(Statement stmt = con.getConnection().createStatement();) {
			
			ResultSet rs = stmt.executeQuery(query);	
    		ResultSetMetaData rsmd = rs.getMetaData();
    		
    		getColumn(rsmd);
    		
    		// Getting the Results
    		while (rs.next()){
    			for (int i = 1; i <= rsmd.getColumnCount(); i++){;
    				System.out.print(rs.getString(i) + "\t\t");
    			}
    			System.out.println();
    		}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * Private function that retrieves the columns selected from the query
	 * @param	rsmd  An object that can be used to get information about the types and properties of the columns in a ResultSet object.
	 * @throws SQLException
	 * @return void
	 */
	private void getColumn(ResultSetMetaData rsmd) throws SQLException{
		// Getting the list of COLUMN Names
		for ( int i=1; i <= rsmd.getColumnCount(); i++){
			System.out.print(rsmd.getColumnName(i) + "\t\t|");
		}
		System.out.println("");
	}
}
