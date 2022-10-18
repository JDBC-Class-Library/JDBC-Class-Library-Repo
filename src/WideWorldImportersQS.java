/**
 * 	WideWorldImportersQS Selects a query to execute from WideWorldImporters database.
 *  @author Almon
 */
public class WideWorldImportersQS extends QuerySelector {
	/**
	 * constructor for WideWorldImportersQS that calls QuerySelector's constructor
	 * @param con A Connector type for already established connection
	 * @param query A String type for querying a database
	 */
	public WideWorldImportersQS(Connector con, String query) {
		super(con, query);
	}


}
