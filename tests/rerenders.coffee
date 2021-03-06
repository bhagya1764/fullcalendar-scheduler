
describe 'rerender performance for resource timeline', ->
	FC = $.fullCalendar
	ResourceTimelineView = FC.ResourceTimelineView

	pushOptions
		defaultDate: '2017-10-04'
		defaultView: 'timelineDay'
		resources: [
			{ id: 'a', title: 'Resource A' }
		]
		events: [
			{ title: 'event 0', start:'2017-10-04', resourceId: 'a' }
		]
		windowResizeDelay: 0

	it 'calls methods a limited number of times', (done) ->
		executeDateRender = spyOnMethod(ResourceTimelineView, 'executeDateRender')
		executeEventRender = spyOnMethod(ResourceTimelineView, 'executeEventRender')
		renderResources = spyOnMethod(ResourceTimelineView, 'renderResources')
		renderResource = spyOnMethod(ResourceTimelineView, 'renderResource')
		updateSize = spyOnMethod(ResourceTimelineView, 'updateSize')

		initCalendar()

		expect(executeDateRender.calls.count()).toBe(1)
		expect(executeEventRender.calls.count()).toBe(1)
		expect(renderResources.calls.count()).toBe(1)
		expect(renderResource.calls.count()).toBe(1)
		expect(updateSize.calls.count()).toBe(1)

		currentCalendar.changeView('agendaWeek')

		expect(executeDateRender.calls.count()).toBe(1)
		expect(executeEventRender.calls.count()).toBe(1)
		expect(renderResources.calls.count()).toBe(1)
		expect(renderResource.calls.count()).toBe(1)
		expect(updateSize.calls.count()).toBe(3) # +2, TODO: get down to +1

		currentCalendar.changeView('timelineDay')

		expect(executeDateRender.calls.count()).toBe(2) # +1
		expect(executeEventRender.calls.count()).toBe(2) # +1
		expect(renderResources.calls.count()).toBe(2) # +1
		expect(renderResource.calls.count()).toBe(2) # +1
		expect(updateSize.calls.count()).toBe(5) # +2, TODO: get down to +1

		currentCalendar.rerenderEvents()

		expect(executeDateRender.calls.count()).toBe(2)
		expect(executeEventRender.calls.count()).toBe(3) # +1
		expect(renderResources.calls.count()).toBe(2)
		expect(renderResource.calls.count()).toBe(2)
		expect(updateSize.calls.count()).toBe(7) # +2, TODO: get down to +1

		currentCalendar.addResource({ title: 'Resource B' })

		expect(executeDateRender.calls.count()).toBe(2)
		expect(executeEventRender.calls.count()).toBe(3)
		expect(renderResources.calls.count()).toBe(2)
		expect(renderResource.calls.count()).toBe(3) # +1
		expect(updateSize.calls.count()).toBe(8) # +1

		$(window).trigger('resize')

		setTimeout ->

			expect(executeDateRender.calls.count()).toBe(2)
			expect(executeEventRender.calls.count()).toBe(3)
			expect(renderResources.calls.count()).toBe(2)
			expect(renderResource.calls.count()).toBe(3)
			expect(updateSize.calls.count()).toBe(9) # +1

			executeDateRender.restore()
			executeEventRender.restore()
			renderResources.restore()
			renderResource.restore()
			updateSize.restore()

			done()
		, 1 # more than windowResizeDelay
