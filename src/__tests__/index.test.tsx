import { createPdfFromImages } from '../index';

describe('createPdfFromImages', () => {
  it('should create a PDF from images and return the output path', async () => {
    // These paths should be replaced with actual test image paths and output path in a real test environment
    const imagePaths = ['/path/to/image1.jpg', '/path/to/image2.jpg'];
    const outputPath = '/tmp/test_output.pdf';
    // This will fail unless run in a real device/simulator with valid paths
    await expect(createPdfFromImages(imagePaths, outputPath)).resolves.toBe(
      outputPath
    );
  });
});
