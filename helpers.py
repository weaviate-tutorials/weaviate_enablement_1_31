import torch
from colpali_engine.models import ColPali, ColPaliProcessor
from typing import Optional
from pathlib import Path


MODEL_NAME = "vidore/colpali-v1.3"


def get_model_and_processor():
    model = ColPali.from_pretrained(
        MODEL_NAME,
        torch_dtype=torch.bfloat16,
        device_map="mps",  # If CUDA is available, use "cuda"
    ).eval()
    processor = ColPaliProcessor.from_pretrained(MODEL_NAME)
    return model, processor


def text_to_colpali(
    texts: list[str],
    model: Optional[ColPali] = None,
    processor: Optional[ColPaliProcessor] = None,
) -> torch.Tensor:
    if not model or not processor:
        model, processor = get_model_and_processor()

    try:
        # Process the text using the processor
        processed_text = processor.process_queries(texts).to(model.device)

        # Get embedding
        with torch.no_grad():
            embeddings = model(**processed_text)

        return embeddings.cpu().float().numpy()

    except Exception as e:
        raise ProcessingError(f"Failed to process text: {str(e)}")



class ProcessingError(Exception):
    pass


def show_local_imgs(img_paths: list):
    import matplotlib.pyplot as plt
    from PIL import Image
    from pathlib import Path
    import math

    n = len(img_paths)
    rows = math.ceil(n / 2)
    cols = 1 if n == 1 else 2
    fig, axes = plt.subplots(rows, cols, figsize=(5 * cols, rows * 3), dpi=250)
    axes = [axes] if n == 1 else axes.flatten()

    for i, p in enumerate(img_paths):
        if type(i) == str:
            p = Path(p)

        axes[i].imshow(Image.open(p))
        axes[i].set_title(f"Result {i+1}")
        axes[i].axis('off')

    for i in range(n, len(axes)):
        axes[i].set_visible(False)

    plt.tight_layout()
    plt.show()



def show_img_results(response):
    img_paths = [o.properties["filepath"] for o in response.objects]
    show_local_imgs(img_paths)
