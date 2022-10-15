/**
 * 	AdventureWorksDW2017QS Selects a query to execute from AdventureWorksDW2017 database.
 *  @author Almon
 */
public class AdventureWorksDW2017QS extends QuerySelector {
	/**
	 * constructor for AdventureWorksDW2017QS that calls QuerySelector's constructor
	 * @param con A Connector type for already established connection
	 * @param query A String type for querying a database
	 */
	public AdventureWorksDW2017QS(Connector con, String query) {
		super(con, query);
	}


}
