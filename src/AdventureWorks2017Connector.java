
/**
 * Connector for AdventureWorks2017 database
 * @author Almon
 */
public class AdventureWorks2017Connector extends Connector {
	/**
	 * Constructor that passes specific database name to Connector
	 */
	public AdventureWorks2017Connector() {
		super("AdventureWorks2017;");
		
	}
	
	/**
	 * Prints database name
	 * @return void
	 */
	@Override
	void printDatabaseName() {
		System.out.println("AdventureWorks2017");
	}
}
