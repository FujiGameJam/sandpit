module main;

import core.runtime;
import core.sys.windows.windows;
import std.stdio;

import fuji.fuji;
import fuji.system;

import game;


version (Windows)
{
	extern (Windows)
	int WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
	{
		int result;

		void exceptionHandler(Throwable e) { throw e; }

		try
		{
			Runtime.initialize(&exceptionHandler);

			MFInitParams initParams;
			initParams.hInstance = hInstance;
			initParams.pCommandLine = lpCmdLine;

			result = GameMain(initParams);

			Runtime.terminate(&exceptionHandler);
		} catch (Throwable o) { result = 0; }

		return result;
	}
}
else
{
	int main(string[] argv)
	{
		int result;
		void exceptionHandler(Throwable e) { throw e; }

		try
		{
			Runtime.initialize(&exceptionHandler);

			MFInitParams initParams;
			result = GameMain(initParams);

			Runtime.terminate(&exceptionHandler);

		} catch (Throwable o) { result = 0; }

		return result;
	}
}
