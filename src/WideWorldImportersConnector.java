/**
 * Connector for WideWorldImporters database
 * @author Almon
 */
public class WideWorldImportersConnector extends Connector {
	/**
	 * Constructor that passes specific database name to Connector
	 */
	public WideWorldImportersConnector() {
		super("WideWorldImporters;");
		
	}
	
	/**
	 * Prints database name
	 * @return void
	 */
	@Override
	void printDatabaseName() {
		System.out.println("WideWorldImporters");
	}
}
