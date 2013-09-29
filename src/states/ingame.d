module states.ingame;

import interfaces.statemachine;
import renderer;
import camera.camera;

import fuji.render;
import fuji.vector;
import fuji.view;

class InGameState : IState
{
	this() { instance = this; }

	void onAdd(StateMachine statemachine) { owner = statemachine; }

	void onEnter() {}
	void onExit() {}
	void onUpdate() {}

	@property StateMachine Owner() { return owner; }
	private StateMachine owner;

	void onRenderWorld()
	{
// 		MFRenderer_ClearScreen(MFRenderClearFlags.All, MFVector.black, 1.0f, 0);
//
// 		MFView_Push();
// 		{
//
// 		}

	}
	@property bool canRenderWorld() { return true; }

	void onRenderGUI(MFRect orthoRect) {

	}
	@property bool canRenderGUI() { return true; }


	private static InGameState instance;
	static @property InGameState Instance() { return instance; }


}
