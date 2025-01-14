# Jimpson's NFT Generator

A robust Python-based NFT generation system using Stable Diffusion, featuring automatic watermarking and hash verification for blockchain integration. This tool powers the NFT collection at jimpsons.org.

## Features

- **AI-Powered Image Generation**: Leverages Stable Diffusion v1.5 for creating unique vector-style artwork
- **Automated Watermarking**: Embeds a custom watermark to protect intellectual property
- **Blockchain-Ready**: Generates SHA-256 hashes for each image, ensuring verifiable uniqueness
- **CUDA-Optimized**: Utilizes GPU acceleration for faster image generation
- **Memory-Efficient**: Implements xformers optimization when available

## Prerequisites

pip install torch diffusers pillow
text

## Project Structure

project/
├── watermark/
│ └── logo_for_watermark.png
├── cache/
├── main.py
└── README.md
text

## Usage

1. Place your watermark image in the `watermark/` directory as `logo_for_watermark.png`
2. Run the script:

python main.py
text

3. Enter your prompts when prompted. The script will:
   - Generate a unique image based on your prompt
   - Add your watermark
   - Calculate a SHA-256 hash
   - Save the image with a UUID filename

## Hash Verification

Each generated image comes with a SHA-256 hash that can be verified online. The hash is calculated using the following process:

- Image is converted to RGB format
- Pixels are processed in BGR order for consistency
- SHA-256 hash is generated from the raw pixel data

## Configuration

The script includes several customizable parameters:

Image Generation Settings
num_inference_steps=30
guidance_scale=10.0
height=512
width=512
Watermark Settings
watermark_size = image.width // 5 # 20% of image size
watermark_position = (image.width - watermark.width - 10,
image.height - watermark.height - 10)
text

## Security Features

- Unique UUID-based filenames for each generation
- Consistent hash generation for blockchain verification
- Watermark protection for intellectual property
- Negative prompts to avoid generating realistic human faces

## Technical Details

The system uses:
- RunwayML's Stable Diffusion v1.5 model
- CUDA acceleration with float16 precision
- PIL for image processing
- SHA-256 for hash generation

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Note

This tool is specifically designed for generating NFTs for jimpsons.org. The hash generation system is compatible with blockchain verification systems and can be integrated with smart contracts for NFT minting.
