
/**
 * Connector for AdventureWorksDW2017 database
 * @author Almon
 */
public class AdventureWorksDW2017Connector extends Connector {
	/**
	 * Constructor that passes specific database name to Connector
	 */
	public AdventureWorksDW2017Connector() {
		super("AdventureWorksDW2017;");
		
	}
	
	/**
	 * Prints database name
	 * @return void
	 */
	@Override
	void printDatabaseName() {
		System.out.println("AdventureWorksDW2017");
	}
}
