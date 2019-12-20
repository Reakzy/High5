import high5.team.high5.Adapter.EventWaitingQueueAdapter
import high5.team.high5.Model.Event
import high5.team.high5.Model.User
import org.junit.Test
import org.mockito.Mockito.*

internal class EventWaitingQueueAdapterTest {

    private val eventWaitingQueueAdapterTest = mock(EventWaitingQueueAdapter::class.java)

    @Test
    fun checkCallGetWaitingUsers() {
        eventWaitingQueueAdapterTest.getWaitingUsers()
        verify(eventWaitingQueueAdapterTest, times(1)).getWaitingUsers()
    }

    @Test
    fun checkCallAddWaitingUserToEvent() {
        val eventMock = mock(Event::class.java)
        val userMock = mock(User::class.java)

        eventWaitingQueueAdapterTest.addWaitingUserToEvent(eventMock, userMock)
        verify(eventWaitingQueueAdapterTest, times(1)).addWaitingUserToEvent(eventMock, userMock)
    }

    @Test
    fun checkCallRemoveWaitingUserToEvent() {
        val eventMock = mock(Event::class.java)
        val userMock = mock(User::class.java)

        eventWaitingQueueAdapterTest.removeWaitingUserToEvent(eventMock, userMock)
        verify(eventWaitingQueueAdapterTest, times(1)).removeWaitingUserToEvent(eventMock, userMock)
    }
}