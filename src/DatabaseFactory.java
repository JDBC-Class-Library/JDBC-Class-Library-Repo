/**
 * Interface designed to produce specific databases that share common methods, but different implementations. 
 *  @author Almon
 */
public interface DatabaseFactory {
	
	/**
	 * Connects a database to a server.
	 * @return	A Connector type 
	 */
	public Connector connectToDatabase();

	/**
	 * Connects a database to a server.
	 * @param connector Utilizes an established connection
	 * @param query String to query a database
	 * @return A Connector type 
	 */
	public QuerySelector executeQuery(Connector connector, String query); 
}
