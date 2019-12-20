import high5.team.high5.Adapter.UserAdapter
import org.junit.Test
import org.mockito.Mockito.*

internal class UserAdapterTest {

    private val userAdapter = mock(UserAdapter::class.java)

    @Test
    fun checkCallGetUser() {
        userAdapter.getUser()
        verify(userAdapter, times(1)).getUser()
    }
}