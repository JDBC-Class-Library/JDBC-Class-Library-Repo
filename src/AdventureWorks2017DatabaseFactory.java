
/**
 * 	AdventureWorks2017 database factory
 *  @author Almon
 */
public class AdventureWorks2017DatabaseFactory implements DatabaseFactory{

	/**
	 * Connects an AdventureWorks2017 database to a server.
	 * @return A AdventureWorks2017Connector type 
	 */
	@Override
	public Connector connectToDatabase() {
			return new AdventureWorks2017Connector();
	}


	/**
	 * Executes a query string
	 * @param con   The Connector to get the connection for this AdventureWorks2017 database.
	 * @param query The query to be executed.
	 * @return A AdventureWorks2017QS type 
	 */
	@Override
	public QuerySelector executeQuery(Connector con, String query) {
		return new AdventureWorks2017QS(con, query);
	}









}
