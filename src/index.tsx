import ImageToPdf from './NativeImageToPdf';

export function multiply(a: number, b: number): number {
  return ImageToPdf.multiply(a, b);
}

/**
 * Converts images to a PDF file using the native module.
 * @param imagePaths Array of image file paths
 * @param outputPath Output PDF file path
 * @returns Promise<string> Resolves to outputPath
 */
export function createPdfFromImages(
  imagePaths: string[],
  outputPath: string
): Promise<string> {
  return ImageToPdf.createPdfFromImages(imagePaths, outputPath);
}
