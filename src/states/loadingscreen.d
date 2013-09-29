module states.loadingscreen;

import interfaces.statemachine;
import interfaces.renderable;

import game;
import renderer;

import fuji.render;
import fuji.material;
import fuji.vector;
import fuji.matrix;
import fuji.primitive;
import fuji.system;


class LoadingScreenState : IState
{
	void onRenderWorld()
	{
		MFRenderer_ClearScreen(MFRenderClearFlags.All, MFVector.black, 1.0f, 0);

		MFView_Push();
		{
			float ratio = Game.Instance.mfInitParams.display.displayRect.width / Game.Instance.mfInitParams.display.displayRect.height;
			MFView_SetAspectRatio(ratio);
			MFView_SetProjection();

			MFView_SetCameraMatrix(MFMatrix.identity);
			MFMaterial_SetMaterial(material);

			MFPrimitive(PrimType.TriStrip | PrimType.Prelit, 0);
			MFBegin(4);
			{
				MFSetTexCoord1(0, 1);
				MFSetPosition(-ratio, -1, ratio);

				MFSetTexCoord1(0, 0);
				MFSetPosition(-ratio, 1, ratio);

				MFSetTexCoord1(1, 1);
				MFSetPosition(ratio, -1, ratio);

				MFSetTexCoord1(1, 0);
				MFSetPosition(ratio, 1, ratio);
			}
			MFEnd();
		}
		MFView_Pop();
	}

	@property bool canRenderWorld() {return true;}
	void onRenderGUI(MFRect orthorect) {}
	@property bool canRenderGUI() {return false;}


	void onAdd(StateMachine statemachine) { owner = statemachine; }

	void onEnter()
	{
		material = MFMaterial_Create("splashscreen");
	}

	void onExit()
	{
		MFMaterial_Release(material);
		material = null;
	}

	void onUpdate()
	{
		elapsedTime += MFSystem_GetTimeDelta();
		if (elapsedTime > 2.5) { owner.switchState("InGame"); }
	}

	private StateMachine owner;
	@property StateMachine Owner() {return owner;}

	private MFMaterial* material;
	float elapsedTime = 0;
}
