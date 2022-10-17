/**
 * Connector for PrestigeCars database
 * @author Almon
 */
public class PrestigeCarsConnector extends Connector {
	/**
	 * Constructor that passes specific database name to Connector
	 */
	public PrestigeCarsConnector() {
		super("PrestigeCars;");
		
	}
	
	/**
	 * Prints database name
	 * @return void
	 */
	@Override
	void printDatabaseName() {
		System.out.println("PrestigeCars");
	}
}
