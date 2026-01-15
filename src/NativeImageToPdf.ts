import { TurboModuleRegistry, type TurboModule } from 'react-native';

export interface Spec extends TurboModule {
  multiply(a: number, b: number): number;
  /**
   * Converts an array of image file paths to a PDF at the given output path.
   * @param imagePaths Array of image file paths
   * @param outputPath Output PDF file path
   * @returns Promise<string> Resolves to outputPath
   */
  convertImagesToPdf(imagePaths: string[], outputPath: string): Promise<string>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('ImageToPdf');
