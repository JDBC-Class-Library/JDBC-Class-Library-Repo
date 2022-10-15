/**
 * 	AdventureWorks2017QS Selects a query to execute from AdventureWorks2017 database.
 *  @author Almon
 */
public class AdventureWorks2017QS extends QuerySelector {
	/**
	 * constructor for AdventureWorks2017QS that calls QuerySelector's constructor
	 * @param con A Connector type for already established connection
	 * @param query A String type for querying a database
	 */
	public AdventureWorks2017QS(Connector con, String query) {
		super(con, query);
	}


}
