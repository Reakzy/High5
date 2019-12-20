import high5.team.high5.Adapter.EventDetailsAdapter
import high5.team.high5.Model.Event
import high5.team.high5.Model.User
import org.junit.Test
import org.mockito.Mockito.*

internal class EventDetailsAdapterTest {

    private val eventDetailsAdapter = mock(EventDetailsAdapter::class.java)

    /* Add Waiting User */
    @Test
    fun checkCallAddWaitingUserWithParameters() {
        val userMock = mock(User::class.java)
        val eventMock = mock(Event::class.java)

        eventDetailsAdapter.addWaitingUser(userMock, eventMock)
        verify(eventDetailsAdapter, times(1)).addWaitingUser(userMock, eventMock)
    }

    @Test
    fun checkCallAddWaitingUserWithFirstParameter() {
        val userMock = mock(User::class.java)

        eventDetailsAdapter.addWaitingUser(userMock, null)
        verify(eventDetailsAdapter, times(1)).addWaitingUser(userMock, null)
    }

    @Test
    fun checkCallAddWaitingUserWithSecondParameter() {
        val eventMock = mock(Event::class.java)

        eventDetailsAdapter.addWaitingUser(null, eventMock)
        verify(eventDetailsAdapter, times(1)).addWaitingUser(null, eventMock)
    }

    @Test
    fun checkCallAddWaitingUserWithOutParameters() {
        eventDetailsAdapter.addWaitingUser(null, null)
        verify(eventDetailsAdapter, times(1)).addWaitingUser(null, null)
    }

    /* Quit */
    @Test
    fun checkCallQuitWithParameters() {
        val userMock = mock(User::class.java)
        val eventMock = mock(Event::class.java)

        eventDetailsAdapter.quit(userMock, eventMock)
        verify(eventDetailsAdapter, times(1)).quit(userMock, eventMock)
    }

    @Test
    fun checkCallQuitWithFirstParameter() {
        val userMock = mock(User::class.java)

        eventDetailsAdapter.quit(userMock, null)
        verify(eventDetailsAdapter, times(1)).quit(userMock, null)
    }

    @Test
    fun checkCallQuitWithSecondParameter() {
        val eventMock = mock(Event::class.java)

        eventDetailsAdapter.quit(null, eventMock)
        verify(eventDetailsAdapter, times(1)).quit(null, eventMock)
    }

    @Test
    fun checkCallQuitWithOutParameters() {
        eventDetailsAdapter.quit(null, null)
        verify(eventDetailsAdapter, times(1)).quit(null, null)
    }

    /* Delete */
    @Test
    fun checkCallDeleteWithParameters() {
        val userMock = mock(User::class.java)
        val eventMock = mock(Event::class.java)

        eventDetailsAdapter.delete(userMock, eventMock)
        verify(eventDetailsAdapter, times(1)).delete(userMock, eventMock)
    }

    @Test
    fun checkCallDeleteWithFirstParameter() {
        val userMock = mock(User::class.java)

        eventDetailsAdapter.delete(userMock, null)
        verify(eventDetailsAdapter, times(1)).delete(userMock, null)
    }

    @Test
    fun checkCallDeleteWithSecondParameter() {
        val eventMock = mock(Event::class.java)

        eventDetailsAdapter.delete(null, eventMock)
        verify(eventDetailsAdapter, times(1)).delete(null, eventMock)
    }

    @Test
    fun checkCallDeleteWithOutParameters() {
        eventDetailsAdapter.delete(null, null)
        verify(eventDetailsAdapter, times(1)).delete(null, null)
    }
}