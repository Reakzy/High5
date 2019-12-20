import high5.team.high5.Adapter.EventCreateAdapter
import high5.team.high5.Model.Event
import high5.team.high5.Model.User
import org.junit.Test
import org.mockito.Mockito.*

internal class EventCreateAdapterTest {

    private val eventCreateAdapter = mock(EventCreateAdapter::class.java)

    @Test
    fun checkCallCreateWithParameters() {
        val userMock = mock(User::class.java)
        val eventMock = mock(Event::class.java)

        eventCreateAdapter.create(eventMock, userMock)
        verify(eventCreateAdapter, times(1)).create(eventMock, userMock)
    }

    @Test
    fun checkCallCreateWithoutParameters() {
        val eventMock = mock(Event::class.java)

        eventCreateAdapter.create(eventMock, null)
        verify(eventCreateAdapter, times(1)).create(eventMock, null)
    }
}