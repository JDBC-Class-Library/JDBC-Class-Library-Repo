/**
* 	PrestigeCars database factory
*  @author Almon
*/
public class PrestigeCarsDatabaseFactory implements DatabaseFactory{

	/**
	 * Connects an PrestigeCars database to a server.
	 * @return A PrestigeCarsConnector type 
	 */
	@Override
	public Connector connectToDatabase() {
			return new PrestigeCarsConnector();
	}


	/**
	 * Executes a query string
	 * @param con   The Connector to get the connection for this PrestigeCars database.
	 * @param query The query to be executed.
	 * @return A PrestigeCarsQS type 
	 */
	@Override
	public QuerySelector executeQuery(Connector con, String query) {
		return new PrestigeCarsQS(con, query);
	}









}
