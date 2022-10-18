/**
 * 	WideWorldImportersDWQS Selects a query to execute from WideWorldImportersDW database.
 *  @author Almon
 */
public class WideWorldImportersDWQS extends QuerySelector {
	/**
	 * constructor for WideWorldImportersDWQS that calls QuerySelector's constructor
	 * @param con A Connector type for already established connection
	 * @param query A String type for querying a database
	 */
	public WideWorldImportersDWQS(Connector con, String query) {
		super(con, query);
	}


}