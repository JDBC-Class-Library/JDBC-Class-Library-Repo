/**
 * 	WideWorldImportersDW database factory
 *  @author Almon
 */
public class WideWorldImportersDWDatabaseFactory implements DatabaseFactory{

	/**
	 * Connects an WideWorldImportersDW database to a server.
	 * @return A WideWorldImportersDWConnector type 
	 */
	@Override
	public Connector connectToDatabase() {
			return new WideWorldImportersDWConnector();
	}


	/**
	 * Executes a query string
	 * @param con   The Connector to get the connection for this WideWorldImportersDW database.
	 * @param query The query to be executed.
	 * @return A WideWorldImportersDWQS type 
	 */
	@Override
	public QuerySelector executeQuery(Connector con, String query) {
		return new WideWorldImportersDWQS(con, query);
	}









}
