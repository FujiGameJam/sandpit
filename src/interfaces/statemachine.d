module interfaces.statemachine;

public import interfaces.renderable;
public import fuji.display;
public import fuji.view;

interface IState : IRenderable
{
	void onAdd(StateMachine statemachine);
	void onEnter();
	void onExit();
	void onUpdate();

	@property StateMachine Owner();
}

class StateMachine
{
	private IState[string] states;
	private IState currState;
	private IState nextState;


	this () {
		currState = null;
		nextState = null;
		states.clear();
	}

	~this() {
		assert(currState is null, "you forgot to shutdown the statemachine dude");
	}

	void shutdown()
	{
		if (currState !is null) { currState.onExit();}
		currState = null;
		nextState = null;
	}

	void addState(string name, IState state)
	{
		foreach(stateName, state; states) { assert(stateName != name, "State " ~ name ~ " already exists!"); }

		states[name] = state;
		state.onAdd(this);
	}

	void switchState(string requestedState)
	{
		foreach (stateName, state; states) {
			if (stateName == requestedState && state != currState) {
				nextState = state;
				break;
			}
		}
	}

	void update()
	{
		if (nextState !is null)
		{
			if (currState !is null) { currState.onExit();}
			currState = nextState;
			currState.onEnter();
			nextState = null;
		}

		if (currState !is null) { currState.onUpdate(); }
	}

	void draw()
	{
		if (currState !is null)
		{
			currState.onRenderWorld();

			MFView_Push();
			{
				MFView_SetDefault();
				MFRect rect;
				MFRect display;

				MFDisplay_GetDisplayRect(&display);
				rect.x = 0.0f;
				rect.y = 0.0f;
				rect.width = 1280;
				rect.height = 720;

				MFView_SetOrtho(&rect);
// 				currState.onRenderGUI(rect);
			}
			MFView_Pop();
		}
	}
}
