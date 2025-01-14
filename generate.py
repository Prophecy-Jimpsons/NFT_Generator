from PIL import Image
import hashlib
from diffusers import StableDiffusionPipeline
import torch
from pathlib import Path
import uuid

def generate_image_hash(image):
    # Convert to RGB and ensure same pixel format as PowerShell
    image = image.convert('RGB')
    # Get raw pixel data in the same format as PowerShell (BGR)
    width, height = image.size
    pixels = []
    for y in range(height):
        for x in range(width):
            r, g, b = image.getpixel((x, y))
            pixels.extend([b, g, r])  # BGR order to match PowerShell
    image_bytes = bytes(pixels)
    # Generate hash
    sha256_hash = hashlib.sha256(image_bytes).hexdigest()
    return sha256_hash




def setup_pipeline():
    # Your existing setup code remains the same
    cache_dir = Path("/app/cache")
    cache_dir.mkdir(exist_ok=True)
    
    model_id = "runwayml/stable-diffusion-v1-5"
    pipe = StableDiffusionPipeline.from_pretrained(
        model_id,
        torch_dtype=torch.float16,
        cache_dir=str(cache_dir),
        local_files_only=False
    )
    
    try:
        pipe.enable_xformers_memory_efficient_attention()
    except ModuleNotFoundError:
        print("xformers not available, using default attention mechanism")

    return pipe.to("cuda")

def generate_image_with_watermark_and_hash(pipe, prompt, watermark_path):
    # Generate unique filename
    filename = f"image_{uuid.uuid4()}.png"
    
    # Generate the image
    image = pipe(
        prompt=prompt + "Create a vector-style cartoon character...",
        negative_prompt="photorealistic portrait of a person, close-up of a face, human head",
        num_inference_steps=30,
        guidance_scale=10.0,
        height=512,
        width=512
    ).images[0]
    
    # Add watermark
    watermark = Image.open(watermark_path).convert("RGBA")
    watermark = watermark.resize((image.width // 5, image.height // 5), Image.Resampling.LANCZOS)
    position = (image.width - watermark.width - 10, image.height - watermark.height - 10)
    
    # Create transparent layer and combine images
    transparent = Image.new("RGBA", image.size, (0, 0, 0, 0))
    transparent.paste(image, (0, 0))
    transparent.paste(watermark, position, mask=watermark)
    
    # Convert to RGB for saving
    final_image = transparent.convert("RGB")
    
    # Generate hash of the watermarked image
    image_hash = generate_image_hash(final_image)
    
    # Save final image
    final_image.save(filename)
    print(f"Image generated successfully as '{filename}'")
    print(f"Image hash: {image_hash}")
    return image_hash

def main():
    print("Initializing Stable Diffusion pipeline...")
    pipe = setup_pipeline()
    watermark_path = "watermark/logo_for_watermark.png"
    print("Pipeline ready! Enter prompts to generate images.")
    print("Type 'exit' to quit.")
    
    while True:
        prompt = input("\nEnter your prompt: ").strip()
        
        if prompt.lower() == 'exit':
            print("Exiting...")
            break
        
        if prompt:
            generate_image_with_watermark_and_hash(pipe, prompt, watermark_path)

if __name__ == "__main__":
    main()
