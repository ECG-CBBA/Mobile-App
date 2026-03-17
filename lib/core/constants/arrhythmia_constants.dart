class ArrhythmiaConstants {
  static const Map<String, String> classNames = {
    'Normal': 'Ritmo sinusal normal',
    'SVEB': 'Latido ectópico supraventricular',
    'VEB': 'Latido ectópico ventricular',
    'Fusion': 'Latido de fusión',
    'Unknown': 'No clasificable / Marcapasos',
  };
  
  static const Map<String, String> classDescriptions = {
    'Normal': 'Ritmo cardíaco normal con complejos QRS regulares',
    'SVEB': 'Contracciones cardíacas prematuras originadas en las aurículas',
    'VEB': 'Contracciones ventriculares prematuras potencialmente graves',
    'Fusion': 'Mezcla de ritmo normal y ventricular',
    'Unknown': 'Patrón no clasificable por el modelo',
  };
  
  static const Map<String, String> classSeverities = {
    'Normal': 'low',
    'SVEB': 'medium',
    'VEB': 'high',
    'Fusion': 'medium',
    'Unknown': 'unknown',
  };
}