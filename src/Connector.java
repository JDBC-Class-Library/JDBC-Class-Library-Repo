import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
/**
 * Connects to a database
 * @author Almon
 */
public abstract class Connector {

	final String SERVER = "jdbc:sqlserver://occam-dbserver.cs.qc.cuny.edu\\dbclass:21433;";
	protected String databaseName = "databaseName=";
	final String ENCRYPTION = "encrypt=false;";

	final String USER = "student";
	final String PASS = "fall2022";
	
	private Connection connection;

	/**
	 * Constructor that connects to a specific database instance
	 * @param databaseName Name of database
	 */
	protected Connector(String databaseName)  {

		this.databaseName+=databaseName;
		connect();

	}
	/**
	 * Code to connect to a specific database
	 */
	private void connect() {
		try {
			String CONNECTIONURL = SERVER+this.databaseName+ENCRYPTION;
			Connection con = DriverManager.getConnection(CONNECTIONURL, USER, PASS);
			connection = con;
			System.out.println("Successfully connected to " + this.databaseName);
		} catch(SQLException e) {
			e.printStackTrace();
		}
	}

	/**
	 * Retrieves Connection variable
	 * @return Connection
	 */
	protected Connection getConnection() {
		return connection;
	}

	/**
	 * abstract method for printing database name
	 */
	abstract void printDatabaseName();
}
