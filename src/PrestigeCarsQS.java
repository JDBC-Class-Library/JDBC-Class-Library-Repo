/**
 * 	PrestigeCarsQS Selects a query to execute from PrestigeCars database.
 *  @author Almon
 */
public class PrestigeCarsQS extends QuerySelector {
	/**
	 * constructor for PrestigeCarsQS that calls QuerySelector's constructor
	 * @param con A Connector type for already established connection
	 * @param query A String type for querying a database
	 */
	public PrestigeCarsQS(Connector con, String query) {
		super(con, query);
	}


}