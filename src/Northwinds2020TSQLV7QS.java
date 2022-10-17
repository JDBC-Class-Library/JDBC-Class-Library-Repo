/**
 * 	Northwinds2020TSQLV7QS Selects a query to execute from Northwinds2020TSQLV7 database.
 *  @author Almon
 */
public class Northwinds2020TSQLV7QS extends QuerySelector {
	/**
	 * constructor for Northwinds2020TSQLV7QS that calls QuerySelector's constructor
	 * @param con A Connector type for already established connection
	 * @param query A String type for querying a database
	 */
	public Northwinds2020TSQLV7QS(Connector con, String query) {
		super(con, query);
	}


}