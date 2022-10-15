
/**
 * 	AdventureWorksDW2017 database factory
 *  @author Almon
 */
public class AdventureWorksDW2017DatabaseFactory implements DatabaseFactory{

	/**
	 * Connects an AdventureWorksDW2017 database to a server.
	 * @return A AdventureWorksDW2017Connector type 
	 */
	@Override
	public Connector connectToDatabase() {
			return new AdventureWorksDW2017Connector();
	}


	/**
	 * Executes a query string
	 * @param con   The Connector to get the connection for this AdventureWorksDW2017 database.
	 * @param query The query to be executed.
	 * @return A AdventureWorksDW2017QS type 
	 */
	@Override
	public QuerySelector executeQuery(Connector con, String query) {
		return new AdventureWorksDW2017QS(con, query);
	}









}
