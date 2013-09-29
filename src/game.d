module game;

// import fuji.fuji;
import fuji.system;
import fuji.filesystem;
import fuji.fs.native;
import fuji.render;
//
import interfaces.statemachine;

import renderer;

import states.loadingscreen;
import states.ingame;

class Game
{
	MFSystemCallbackFunction pInitFujiFS = null;
	MFRenderer *pRenderer = null;

	this () {
		instance = this;
		state = new StateMachine;
	}

	void init()
	{
		Renderer.Instance();
		state.addState("LoadingScreen", new LoadingScreenState());
		state.addState("InGame", new InGameState());
		state.switchState("LoadingScreen");
	}

	void shutdown() { state.shutdown(); }
	void draw() { state.draw(); }
	void update() { state.update(); }

	void initFileSystem()
	{
		MFFileSystemHandle hNative = MFFileSystem_GetInternalFileSystemHandle(MFFileSystemHandles.NativeFileSystem);
		MFMountDataNative mountData;
		mountData.flags = MFMountFlags.FlattenDirectoryStructure | MFMountFlags.Recursive;
		mountData.pMountpoint = "game".ptr;
		mountData.pPath = MFFile_SystemPath("data/");
		MFFileSystem_Mount(hNative, mountData);

		if (pInitFujiFS) pInitFujiFS();
	}

	private StateMachine state;

	MFInitParams mfInitParams;
	private static Game instance;
	@property static Game Instance() { if (instance is null) instance = new Game; return instance;}
	extern (C) static void staticInit() { Instance.init(); }
	extern (C) static void staticShutdown() { Instance.shutdown(); instance = null; }
	extern (C) static void staticUpdate() { Instance.update(); }
	extern (C) static void staticDraw() { Instance.draw();}
	extern (C) static void staticInitFileSystem() { Instance.initFileSystem(); }
}

int GameMain (ref MFInitParams initParams) {
	MFSystem_RegisterSystemCallback(MFCallback.InitDone, &Game.staticInit);
	MFSystem_RegisterSystemCallback(MFCallback.Update, &Game.staticUpdate);
	MFSystem_RegisterSystemCallback(MFCallback.Deinit, &Game.staticShutdown);
	MFSystem_RegisterSystemCallback(MFCallback.Draw, &Game.staticDraw);

	Game.Instance.pInitFujiFS = MFSystem_RegisterSystemCallback(MFCallback.FileSystemInit, &Game.staticInitFileSystem);
	return MFMain(initParams);
}
