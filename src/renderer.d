module renderer;

import fuji.render;
import fuji.vector;
import fuji.texture;
import fuji.material;
import std.string;

class Renderer
{
	private static Renderer instance;

	private MFRenderer* pRenderer;
	private size_t currentLayer;
	
	private MFTexture* pRT;
	private MFTexture* pZT;
	private MFMaterial* pRTMat;

	this()
	{
		string[] layers = ["Background"];
		MFRenderLayerDescription[] l = new MFRenderLayerDescription[layers.length];
		foreach(i; 0..layers.length) {  l[i].pName = layers[i].toStringz(); }
		pRenderer = MFRenderer_Create(l.ptr, cast(int)l.length, null, null);
		MFRenderer_SetCurrent(pRenderer);


		setBackgroundLayer();

		MFVector clearColour = MFVector(0,0,0.2,1);
		MFRenderLayer_SetClear(CurrentLayer(),MFRenderClearFlags.All, clearColour);

	}

	~this()
	{
		MFRenderer_Destroy(pRenderer);
	}

	MFRenderLayer* layer(size_t i) { return MFRenderer_GetLayer(pRenderer, cast(int)i); }
	@property MFRenderLayer* CurrentLayer() { return layer(currentLayer); }
	void setBackgroundLayer() { setCurrentLayer(0); }

	void setCurrentLayer(size_t i)
	{
		MFRenderLayerSet layerSet;
		layerSet.pSolidLayer = layer(i);
		MFRenderer_SetRenderLayerSet(pRenderer, &layerSet);
		currentLayer = i;
	}

	@property static Renderer Instance() { if (instance is null) instance = new Renderer; return instance; }

}
