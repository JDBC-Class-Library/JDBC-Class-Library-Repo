/**
 * Connector for AdventureWorks2017 database
 * @author Almon
 */
public class WideWorldImportersDWConnector extends Connector {
	/**
	 * Constructor that passes specific database name to Connector
	 */
	public WideWorldImportersDWConnector() {
		super("WideWorldImportersDW;");	
	}
	
	/**
	 * Prints database name
	 * @return void
	 */
	@Override
	void printDatabaseName() {
		System.out.println("WideWorldImportersDW");
	}
}
