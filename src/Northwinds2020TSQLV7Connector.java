
/**
 * Connector for AdventureWorks2017 database
 * @author Almon
 */
public class Northwinds2020TSQLV7Connector extends Connector {
	/**
	 * Constructor that passes specific database name to Connector
	 */
	public Northwinds2020TSQLV7Connector() {
		super("Northwinds2020TSQLV7;");	
	}
	
	/**
	 * Prints database name
	 * @return void
	 */
	@Override
	void printDatabaseName() {
		System.out.println("Northwinds2020TSQLV7");
	}
}
