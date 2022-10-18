 /**
 * 	Northwinds2020TSQLV7 database factory
 *  @author Almon
 */
public class Northwinds2020TSQLV7DatabaseFactory implements DatabaseFactory{

	/**
	 * Connects an Northwinds2020TSQLV7 database to a server.
	 * @return A Northwinds2020TSQLV7Connector type 
	 */
	@Override
	public Connector connectToDatabase() {
			return new Northwinds2020TSQLV7Connector();
	}


	/**
	 * Executes a query string
	 * @param con   The Connector to get the connection for this Northwinds2020TSQLV7 database.
	 * @param query The query to be executed.
	 * @return A Northwinds2020TSQLV7QS type 
	 */
	@Override
	public QuerySelector executeQuery(Connector con, String query) {
		return new Northwinds2020TSQLV7QS(con, query);
	}









}
