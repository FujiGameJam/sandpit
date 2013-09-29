module interfaces.renderable;

public import fuji.types;

interface IRenderable
{
	void onRenderWorld();
	void onRenderGUI(MFRect orthoRect);

	@property bool canRenderWorld();
	@property bool canRenderGUI();
}
