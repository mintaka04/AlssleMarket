package test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.fail;

import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import dao.LoginDAO;

class JUnitTest {

	@BeforeAll
	static void setUpBeforeClass() throws Exception {
	}

	@AfterAll
	static void tearDownAfterClass() throws Exception {
	}

	@BeforeEach
	void setUp() throws Exception {
	}

	@AfterEach
	void tearDown() throws Exception {
	}

	@Test
	void testLoginDAO() {
		//fail("Not yet implemented");
	}

	@Test
	void testIsExistsStringString() {
		//fail("Not yet implemented");
		//LoginDAO dao = new LoginDAO();
		//assertEquals(true, dao.isExists("jarrett@gmail.com", "8787"));
	}

	@Test
	void testIsExistsString() {
		//fail("Not yet implemented");
		LoginDAO dao = new LoginDAO();
		assertEquals("true", dao.isExists("imymemine@daum.net"));

	}

	@Test
	void testInsertOne() {
		//fail("Not yet implemented");
	}

	@Test
	void testUpdateOne() {
		//fail("Not yet implemented");
	}

	@Test
	void testImgOne() {
		//fail("Not yet implemented");
	}

	@Test
	void testClose() {
		//fail("Not yet implemented");
	}

}
