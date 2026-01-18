import { TurboModuleRegistry, type TurboModule } from 'react-native';

export interface Spec extends TurboModule {
  /**
   * Creates a PDF from an array of image file paths at the given output path.
   * @param imagePaths Array of image file paths
   * @param outputPath Output PDF file path
   * @returns Promise<string> Resolves to outputPath
   */
  createPdfFromImages(
    imagePaths: string[],
    outputPath: string
  ): Promise<string>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('ImageToPdf');
