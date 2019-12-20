import high5.team.high5.Adapter.MessageAdapter
import org.junit.Test
import org.mockito.Mockito.*

internal class MessageAdapterTest {

    private val messageAdapter = mock(MessageAdapter::class.java)

    @Test
    fun checkCallGetUsers() {
        messageAdapter.getUsers()
        verify(messageAdapter, times(1)).getUsers()
    }

    @Test
    fun checkCallGetMessages() {
        messageAdapter.getMessages()
        verify(messageAdapter, times(1)).getMessages()
    }

    @Test
    fun checkCallWrittingMessage() {
        messageAdapter.writtingMessage("", "", "")
        verify(messageAdapter, times(1)).writtingMessage("", "", "")
    }
}