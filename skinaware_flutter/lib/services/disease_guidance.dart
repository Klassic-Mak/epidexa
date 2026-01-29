/// Static guidance information for skin diseases detected by the offline model
class DiseaseGuidance {
  /// Get guidance for a specific disease
  static DiseaseGuidanceInfo getGuidance(String disease) {
    return _guidanceMap[disease] ?? _defaultGuidance;
  }

  static final Map<String, DiseaseGuidanceInfo> _guidanceMap = {
    'Acne and Rosacea': const DiseaseGuidanceInfo(
      disease: 'Acne and Rosacea',
      description:
          'Acne is a skin condition that occurs when hair follicles become clogged with oil and dead skin cells. Rosacea is a chronic skin condition causing redness and visible blood vessels on the face.',
      causes: [
        'Excess oil (sebum) production',
        'Clogged hair follicles',
        'Bacteria buildup',
        'Hormonal changes',
        'Genetic factors',
        'Spicy foods and alcohol (for rosacea)',
      ],
      symptoms: [
        'Whiteheads and blackheads',
        'Pimples and pustules',
        'Facial redness',
        'Visible blood vessels',
        'Skin sensitivity',
        'Bumpy texture',
      ],
      recommendations:
          'Maintain a gentle skincare routine with non-comedogenic products. Wash face twice daily with a mild cleanser. Avoid picking or squeezing pimples. Use oil-free moisturizers and sunscreen. For rosacea, identify and avoid triggers like spicy foods, alcohol, and extreme temperatures.',
      homeRemedies: [
        'Apply tea tree oil diluted with carrier oil',
        'Use honey masks for antibacterial benefits',
        'Apply aloe vera gel to soothe inflammation',
        'Use green tea as a toner',
        'Apply cold compresses for redness',
      ],
      whenToSeeDoctor:
          'See a dermatologist if acne is severe, leaves scars, or does not respond to over-the-counter treatments after 2-3 months. For rosacea, consult if symptoms worsen or affect your eyes.',
      requiresUrgentCare: false,
    ),
    'Actinic Keratosis and Malignant Lesions': const DiseaseGuidanceInfo(
      disease: 'Actinic Keratosis and Malignant Lesions',
      description:
          'Actinic keratosis is a rough, scaly patch on the skin caused by years of sun exposure. It can potentially develop into skin cancer if left untreated.',
      causes: [
        'Prolonged sun exposure',
        'UV radiation damage',
        'Fair skin',
        'Age over 40',
        'History of sunburns',
        'Weakened immune system',
      ],
      symptoms: [
        'Rough, dry, scaly patches',
        'Flat to slightly raised lesions',
        'Color varies: pink, red, or brown',
        'Itching or burning sensation',
        'Patches that come and go',
        'Crusty or horn-like growths',
      ],
      recommendations:
          'IMPORTANT: Seek medical evaluation promptly. Protect skin from further sun damage with SPF 30+ sunscreen, protective clothing, and avoiding peak sun hours. Do not attempt to remove lesions at home. Regular skin checks are essential.',
      homeRemedies: [
        'Apply sunscreen religiously (SPF 30+)',
        'Wear protective clothing and hats',
        'Stay in shade during peak sun hours',
        'Keep skin moisturized',
        'Monitor lesions for changes',
      ],
      whenToSeeDoctor:
          'See a dermatologist immediately for any suspicious skin growth. This condition requires professional evaluation to rule out skin cancer. Regular skin cancer screenings are recommended.',
      requiresUrgentCare: true,
    ),
    'Atopic Dermatitis': const DiseaseGuidanceInfo(
      disease: 'Atopic Dermatitis',
      description:
          'Atopic dermatitis (eczema) is a chronic condition that causes dry, itchy, and inflamed skin. It is common in children but can occur at any age.',
      causes: [
        'Genetic factors',
        'Immune system dysfunction',
        'Environmental triggers',
        'Dry skin',
        'Stress',
        'Allergens and irritants',
      ],
      symptoms: [
        'Dry, cracked skin',
        'Intense itching',
        'Red to brownish-gray patches',
        'Small raised bumps that may leak fluid',
        'Thickened, scaly skin',
        'Raw, sensitive skin from scratching',
      ],
      recommendations:
          'Keep skin well moisturized with fragrance-free creams. Take short, lukewarm baths and apply moisturizer immediately after. Identify and avoid triggers. Use gentle, fragrance-free soaps and detergents. Wear soft, breathable fabrics like cotton.',
      homeRemedies: [
        'Apply coconut oil as a natural moisturizer',
        'Use colloidal oatmeal baths',
        'Apply cool, wet compresses to itchy areas',
        'Use a humidifier to add moisture to air',
        'Wear cotton gloves at night to prevent scratching',
      ],
      whenToSeeDoctor:
          'Consult a doctor if itching interferes with sleep or daily activities, skin becomes painful or shows signs of infection (oozing, crusting), or if over-the-counter treatments are not helping.',
      requiresUrgentCare: false,
    ),
    'Bullous Disease': const DiseaseGuidanceInfo(
      disease: 'Bullous Disease',
      description:
          'Bullous diseases are a group of conditions characterized by large, fluid-filled blisters on the skin. These can be autoimmune conditions where the body attacks its own skin.',
      causes: [
        'Autoimmune disorders',
        'Genetic factors',
        'Medications',
        'Infections',
        'Burns or injuries',
        'Unknown causes',
      ],
      symptoms: [
        'Large blisters filled with clear fluid',
        'Blisters that break easily',
        'Raw, painful skin after blister rupture',
        'Itching or burning',
        'Skin that peels easily',
        'Blisters in mouth or other mucous membranes',
      ],
      recommendations:
          'Seek medical attention for proper diagnosis and treatment. Do not pop or break blisters as this can lead to infection. Keep affected areas clean and protected. Avoid trauma to the skin. Follow prescribed treatment carefully.',
      homeRemedies: [
        'Keep blisters clean and covered',
        'Use sterile bandages to protect broken blisters',
        'Apply petroleum jelly to prevent sticking',
        'Keep affected areas elevated if swollen',
        'Wear loose, soft clothing',
      ],
      whenToSeeDoctor:
          'See a doctor promptly if you develop unexplained blisters, especially if they are large, widespread, or appear in the mouth. Immediate care is needed if blisters show signs of infection.',
      requiresUrgentCare: true,
    ),
    'Cellulitis and Bacterial Infections': const DiseaseGuidanceInfo(
      disease: 'Cellulitis and Bacterial Infections',
      description:
          'Cellulitis is a common bacterial skin infection that causes redness, swelling, and pain in the affected area. It can spread rapidly and become serious if not treated.',
      causes: [
        'Bacteria entering through broken skin',
        'Cuts, scrapes, or insect bites',
        'Skin conditions like eczema',
        'Weakened immune system',
        'Poor circulation',
        'Lymphedema',
      ],
      symptoms: [
        'Red, swollen, tender skin',
        'Warmth in affected area',
        'Pain or tenderness',
        'Fever and chills',
        'Red streaks spreading from the area',
        'Skin that looks tight or glossy',
      ],
      recommendations:
          'SEEK MEDICAL CARE PROMPTLY. Cellulitis requires antibiotic treatment. Keep the affected area elevated to reduce swelling. Apply cool compresses for comfort. Complete the full course of antibiotics as prescribed.',
      homeRemedies: [
        'Elevate affected limb above heart level',
        'Apply cool, clean compresses',
        'Keep wound clean and covered',
        'Rest the affected area',
        'Stay hydrated and get adequate rest',
      ],
      whenToSeeDoctor:
          'Seek immediate medical attention if you have spreading redness, fever, or red streaks from the wound. Emergency care is needed if you have high fever, rapid spreading, or feel very unwell.',
      requiresUrgentCare: true,
    ),
    'Eczema': const DiseaseGuidanceInfo(
      disease: 'Eczema',
      description:
          'Eczema is a condition that makes skin red, inflamed, and itchy. It is common in children but can occur at any age and tends to flare periodically.',
      causes: [
        'Genetic predisposition',
        'Overactive immune response',
        'Environmental triggers',
        'Irritants in soaps and detergents',
        'Allergens',
        'Stress and hormonal changes',
      ],
      symptoms: [
        'Dry, sensitive skin',
        'Intense itching',
        'Red, inflamed skin',
        'Dark colored patches',
        'Rough, leathery patches',
        'Oozing or crusting',
      ],
      recommendations:
          'Moisturize skin at least twice daily with thick creams or ointments. Use mild, fragrance-free cleansers. Avoid known triggers. Take lukewarm (not hot) baths. Pat skin dry gently and apply moisturizer immediately.',
      homeRemedies: [
        'Apply coconut oil to affected areas',
        'Take oatmeal baths to soothe itching',
        'Use aloe vera gel for cooling relief',
        'Apply sunflower seed oil to improve skin barrier',
        'Use honey for its antibacterial properties',
      ],
      whenToSeeDoctor:
          'See a doctor if eczema affects sleep or daily activities, appears infected (yellow crusting, pus), does not improve with home care, or covers large areas of the body.',
      requiresUrgentCare: false,
    ),
    'Exanthems and Drug Eruptions': const DiseaseGuidanceInfo(
      disease: 'Exanthems and Drug Eruptions',
      description:
          'Exanthems are widespread rashes often associated with viral infections or drug reactions. Drug eruptions are adverse skin reactions to medications.',
      causes: [
        'Viral infections',
        'Allergic reactions to medications',
        'Antibiotics (common culprits)',
        'NSAIDs and other medications',
        'Immune system response',
        'Unknown triggers',
      ],
      symptoms: [
        'Widespread rash',
        'Red or pink spots or patches',
        'Fever',
        'Itching',
        'Swelling',
        'May have blisters in severe cases',
      ],
      recommendations:
          'If you suspect a drug reaction, note what medications you have taken recently. Do not stop prescription medications without consulting a doctor first. Seek medical evaluation to determine the cause and appropriate treatment.',
      homeRemedies: [
        'Take cool baths to soothe skin',
        'Apply calamine lotion for itching',
        'Use antihistamines as directed',
        'Wear loose, comfortable clothing',
        'Keep a diary of medications and symptoms',
      ],
      whenToSeeDoctor:
          'Seek immediate care if rash is accompanied by difficulty breathing, facial swelling, high fever, or blistering. These could indicate a severe allergic reaction requiring emergency treatment.',
      requiresUrgentCare: true,
    ),
    'Hair Loss and Alopecia': const DiseaseGuidanceInfo(
      disease: 'Hair Loss and Alopecia',
      description:
          'Alopecia refers to hair loss from any part of the body. It can range from small patches to complete loss of all body hair and has various causes.',
      causes: [
        'Genetic factors (pattern baldness)',
        'Autoimmune conditions',
        'Hormonal changes',
        'Medical treatments (chemotherapy)',
        'Stress',
        'Nutritional deficiencies',
      ],
      symptoms: [
        'Gradual thinning on top of head',
        'Circular bald patches',
        'Sudden loosening of hair',
        'Full-body hair loss',
        'Patches of scaling on scalp',
        'Widening part line',
      ],
      recommendations:
          'Be gentle with hair - avoid tight hairstyles and harsh treatments. Eat a balanced diet rich in protein and iron. Manage stress through relaxation techniques. Protect hair from sun damage. Avoid excessive heat styling.',
      homeRemedies: [
        'Massage scalp to stimulate blood flow',
        'Use essential oils like rosemary or peppermint',
        'Take biotin supplements (consult doctor first)',
        'Apply onion juice to scalp',
        'Use gentle, sulfate-free shampoos',
      ],
      whenToSeeDoctor:
          'Consult a dermatologist if hair loss is sudden or in patches, accompanied by itching or pain, or if you notice scalp changes. Early treatment often leads to better outcomes.',
      requiresUrgentCare: false,
    ),
    'Herpes HPV and STDs': const DiseaseGuidanceInfo(
      disease: 'Herpes HPV and STDs',
      description:
          'This category includes skin manifestations of sexually transmitted infections including herpes simplex virus (HSV) and human papillomavirus (HPV).',
      causes: [
        'Viral infections',
        'Sexual contact',
        'Skin-to-skin contact',
        'Mother-to-child transmission',
        'Sharing personal items',
        'Compromised immune system',
      ],
      symptoms: [
        'Painful blisters or sores',
        'Warts (genital or common)',
        'Itching or tingling',
        'Burning sensation',
        'Flu-like symptoms during outbreaks',
        'Recurring lesions',
      ],
      recommendations:
          'Seek confidential medical evaluation for proper diagnosis and treatment. Practice safe sex. Avoid contact with lesions during outbreaks. Inform partners about your condition. Follow prescribed antiviral treatments.',
      homeRemedies: [
        'Keep affected areas clean and dry',
        'Apply cold compresses to soothe pain',
        'Wear loose, cotton underwear',
        'Take warm baths to ease discomfort',
        'Manage stress to reduce outbreaks',
      ],
      whenToSeeDoctor:
          'See a healthcare provider for any suspected STD symptoms, new or changing lesions, or if you have been exposed to an STD. Regular screening is important for sexually active individuals.',
      requiresUrgentCare: false,
    ),
    'Pigmentation Disorders': const DiseaseGuidanceInfo(
      disease: 'Pigmentation Disorders',
      description:
          'Pigmentation disorders affect the color of skin, causing it to become lighter, darker, or discolored. Common conditions include vitiligo, melasma, and post-inflammatory hyperpigmentation.',
      causes: [
        'Autoimmune conditions',
        'Sun exposure',
        'Hormonal changes',
        'Skin injuries or inflammation',
        'Genetic factors',
        'Certain medications',
      ],
      symptoms: [
        'Light or white patches (vitiligo)',
        'Dark patches (melasma)',
        'Uneven skin tone',
        'Spots that change over time',
        'Patches on sun-exposed areas',
        'Symmetrical discoloration',
      ],
      recommendations:
          'Protect skin from sun exposure with SPF 30+ sunscreen daily. Avoid skin trauma. Use gentle skincare products. Consider cosmetic camouflage for visible areas if desired. Be patient - treatment takes time.',
      homeRemedies: [
        'Apply sunscreen religiously',
        'Use vitamin C serums for brightening',
        'Try natural lighteners like licorice extract',
        'Use aloe vera for soothing',
        'Apply turmeric paste (test first)',
      ],
      whenToSeeDoctor:
          'Consult a dermatologist for proper diagnosis, especially if pigmentation changes suddenly or spreads rapidly. Treatment options vary based on the specific condition.',
      requiresUrgentCare: false,
    ),
    'Lupus and Connective Tissue Diseases': const DiseaseGuidanceInfo(
      disease: 'Lupus and Connective Tissue Diseases',
      description:
          'Lupus is an autoimmune disease that can affect skin, joints, and organs. The characteristic butterfly rash on the face is a common sign.',
      causes: [
        'Autoimmune dysfunction',
        'Genetic predisposition',
        'Environmental triggers',
        'Hormonal factors',
        'Certain medications',
        'UV light exposure',
      ],
      symptoms: [
        'Butterfly-shaped facial rash',
        'Photosensitivity',
        'Joint pain and swelling',
        'Fatigue',
        'Fever',
        'Skin lesions that worsen with sun',
      ],
      recommendations:
          'SEEK MEDICAL EVALUATION for proper diagnosis and management. Protect skin from sun exposure rigorously. Manage stress. Get adequate rest. Follow treatment plan closely. Join a support group if helpful.',
      homeRemedies: [
        'Apply SPF 50+ sunscreen daily',
        'Wear protective clothing outdoors',
        'Get plenty of rest',
        'Manage stress through relaxation',
        'Eat anti-inflammatory foods',
      ],
      whenToSeeDoctor:
          'See a rheumatologist or dermatologist if you suspect lupus. Seek immediate care for severe symptoms like chest pain, difficulty breathing, or sudden severe headache.',
      requiresUrgentCare: true,
    ),
    'Melanoma and Skin Cancer': const DiseaseGuidanceInfo(
      disease: 'Melanoma and Skin Cancer',
      description:
          'Melanoma is the most serious type of skin cancer, developing from pigment-producing cells. Early detection is critical for successful treatment.',
      causes: [
        'UV radiation exposure',
        'History of sunburns',
        'Many moles',
        'Fair skin',
        'Family history',
        'Weakened immune system',
      ],
      symptoms: [
        'Asymmetrical mole',
        'Irregular borders',
        'Multiple colors in one mole',
        'Diameter larger than 6mm',
        'Evolving size, shape, or color',
        'New unusual growths',
      ],
      recommendations:
          'SEEK IMMEDIATE MEDICAL EVALUATION. Do not delay - early detection saves lives. Do not attempt to remove or treat suspicious lesions yourself. Protect skin from further sun damage.',
      homeRemedies: [
        'Perform monthly skin self-exams',
        'Use ABCDE rule to monitor moles',
        'Apply sunscreen daily (SPF 30+)',
        'Avoid tanning beds',
        'Photograph moles to track changes',
      ],
      whenToSeeDoctor:
          'See a dermatologist IMMEDIATELY for any suspicious mole or skin growth, especially if it changes in size, shape, or color, or if it bleeds, itches, or does not heal.',
      requiresUrgentCare: true,
    ),
    'Nail Fungus and Nail Disease': const DiseaseGuidanceInfo(
      disease: 'Nail Fungus and Nail Disease',
      description:
          'Nail fungus (onychomycosis) is a common condition causing thickened, discolored, and brittle nails. It typically starts as a white or yellow spot under the nail tip.',
      causes: [
        'Fungal infection',
        'Warm, moist environments',
        'Walking barefoot in public areas',
        'Nail injuries',
        'Poor circulation',
        'Weakened immune system',
      ],
      symptoms: [
        'Thickened nails',
        'Whitish to yellow-brown discoloration',
        'Brittle, crumbly nails',
        'Distorted nail shape',
        'Dark color from debris buildup',
        'Slightly foul odor',
      ],
      recommendations:
          'Keep nails trimmed short and dry. Wear breathable socks and shoes. Use antifungal powder in shoes. Avoid walking barefoot in public areas. Disinfect nail clippers. Treatment takes months - be patient.',
      homeRemedies: [
        'Apply tea tree oil to affected nails',
        'Soak nails in diluted apple cider vinegar',
        'Use Vicks VapoRub on affected nails',
        'Apply garlic paste (crushed garlic)',
        'Keep nails clean and dry',
      ],
      whenToSeeDoctor:
          'See a doctor if home remedies do not work after several months, if you have diabetes, circulation problems, or weakened immunity, or if nails become painful.',
      requiresUrgentCare: false,
    ),
    'Contact Dermatitis': const DiseaseGuidanceInfo(
      disease: 'Contact Dermatitis',
      description:
          'Contact dermatitis is a red, itchy rash caused by direct contact with an irritant or allergen. Common triggers include poison ivy, nickel, and certain chemicals.',
      causes: [
        'Plants (poison ivy, oak, sumac)',
        'Metals (nickel in jewelry)',
        'Cosmetics and skincare products',
        'Soaps and detergents',
        'Latex',
        'Chemicals and solvents',
      ],
      symptoms: [
        'Red, itchy rash',
        'Burning or stinging',
        'Blisters that may ooze',
        'Dry, cracked, scaly skin',
        'Swelling',
        'Rash in pattern of contact',
      ],
      recommendations:
          'Identify and avoid the trigger. Wash affected area immediately after contact. Apply cool compresses. Use over-the-counter hydrocortisone cream. Take antihistamines for itching. Wear protective gloves when handling irritants.',
      homeRemedies: [
        'Apply cool, wet compresses',
        'Take oatmeal baths',
        'Apply calamine lotion',
        'Use aloe vera gel',
        'Apply baking soda paste for itching',
      ],
      whenToSeeDoctor:
          'See a doctor if the rash is widespread or on the face, does not improve within 2-3 weeks, becomes infected (oozing, pus), or causes significant discomfort.',
      requiresUrgentCare: false,
    ),
    'Psoriasis and Lichen Planus': const DiseaseGuidanceInfo(
      disease: 'Psoriasis and Lichen Planus',
      description:
          'Psoriasis is a chronic autoimmune condition causing rapid skin cell buildup, leading to scaling. Lichen planus causes purple, itchy, flat bumps on skin and mucous membranes.',
      causes: [
        'Immune system dysfunction',
        'Genetic factors',
        'Stress',
        'Infections',
        'Skin injuries',
        'Certain medications',
      ],
      symptoms: [
        'Red patches with silvery scales (psoriasis)',
        'Purple, flat-topped bumps (lichen planus)',
        'Dry, cracked skin that may bleed',
        'Itching and burning',
        'Thickened, pitted nails',
        'Stiff, swollen joints',
      ],
      recommendations:
          'Keep skin moisturized. Avoid triggers like stress, alcohol, and smoking. Get moderate sunlight (but avoid sunburn). Use prescribed topical treatments consistently. Consider phototherapy under medical supervision.',
      homeRemedies: [
        'Apply thick moisturizers after bathing',
        'Take warm (not hot) baths with bath oil',
        'Use a humidifier at home',
        'Apply aloe vera gel',
        'Try fish oil supplements (consult doctor)',
      ],
      whenToSeeDoctor:
          'See a dermatologist for proper diagnosis and treatment plan. Seek care if symptoms worsen, affect quality of life, or if you develop joint pain.',
      requiresUrgentCare: false,
    ),
    'Scabies and Infestations': const DiseaseGuidanceInfo(
      disease: 'Scabies and Infestations',
      description:
          'Scabies is a contagious skin condition caused by tiny mites that burrow into the skin. Lyme disease results from tick bites and can cause distinctive rashes.',
      causes: [
        'Scabies mites (Sarcoptes scabiei)',
        'Tick bites (Lyme disease)',
        'Bedbugs',
        'Fleas',
        'Close personal contact',
        'Sharing bedding or clothing',
      ],
      symptoms: [
        'Intense itching, especially at night',
        'Thin, irregular burrow tracks',
        'Small bumps or blisters',
        'Bulls-eye rash (Lyme disease)',
        'Rash in skin folds',
        'Secondary infection from scratching',
      ],
      recommendations:
          'Seek medical treatment - prescription medications are required for scabies. Wash all bedding and clothing in hot water. Treat all household members and close contacts simultaneously. Avoid scratching to prevent infection.',
      homeRemedies: [
        'Apply cool compresses for itching',
        'Take antihistamines as directed',
        'Use calamine lotion',
        'Clean and vacuum living spaces thoroughly',
        'Bag items that cannot be washed for 72 hours',
      ],
      whenToSeeDoctor:
          'See a doctor promptly for suspected scabies or tick bites. Scabies requires prescription treatment. Lyme disease needs antibiotics - early treatment is important.',
      requiresUrgentCare: true,
    ),
    'Seborrheic Keratoses and Benign Tumors': const DiseaseGuidanceInfo(
      disease: 'Seborrheic Keratoses and Benign Tumors',
      description:
          'Seborrheic keratoses are common non-cancerous skin growths that appear as waxy, wart-like growths. They are harmless but can be cosmetically concerning.',
      causes: [
        'Aging',
        'Genetic factors',
        'Sun exposure',
        'Unknown exact cause',
        'Friction from clothing',
        'Skin irritation',
      ],
      symptoms: [
        'Waxy, stuck-on appearance',
        'Round or oval shape',
        'Brown, black, or tan color',
        'Slightly raised growths',
        'Scaly or wart-like texture',
        'Range from tiny to large',
      ],
      recommendations:
          'These growths are typically harmless and do not require treatment. However, get any new or changing growths evaluated by a dermatologist to rule out skin cancer. Removal is an option for cosmetic reasons or if they become irritated.',
      homeRemedies: [
        'No home removal recommended',
        'Keep area clean and dry',
        'Avoid picking or scratching',
        'Protect from sun exposure',
        'Monitor for changes',
      ],
      whenToSeeDoctor:
          'See a dermatologist if growths change in appearance, bleed, become irritated, or if you are unsure whether a growth is benign. Any rapidly changing lesion needs evaluation.',
      requiresUrgentCare: false,
    ),
    'Systemic Disease': const DiseaseGuidanceInfo(
      disease: 'Systemic Disease',
      description:
          'Skin manifestations of systemic diseases can indicate underlying health conditions affecting multiple organ systems, such as diabetes, thyroid disorders, or liver disease.',
      causes: [
        'Diabetes mellitus',
        'Thyroid disorders',
        'Liver disease',
        'Kidney disease',
        'Autoimmune conditions',
        'Hormonal imbalances',
      ],
      symptoms: [
        'Skin discoloration',
        'Unusual rashes',
        'Dry, itchy skin',
        'Slow wound healing',
        'Skin thickening',
        'Changes in skin texture',
      ],
      recommendations:
          'SEEK MEDICAL EVALUATION to identify any underlying systemic condition. Skin changes can be important indicators of internal health issues. Work with healthcare providers to manage the underlying condition.',
      homeRemedies: [
        'Keep skin well moisturized',
        'Eat a balanced, healthy diet',
        'Stay hydrated',
        'Get regular exercise',
        'Monitor blood sugar if diabetic',
      ],
      whenToSeeDoctor:
          'See a doctor if you notice unexplained skin changes, especially if accompanied by other symptoms like fatigue, weight changes, or feeling unwell. Early diagnosis of systemic diseases is important.',
      requiresUrgentCare: true,
    ),
    'Fungal Infections': const DiseaseGuidanceInfo(
      disease: 'Fungal Infections',
      description:
          'Fungal skin infections include ringworm, athlete\'s foot, jock itch, and candidiasis. They thrive in warm, moist environments and are generally treatable.',
      causes: [
        'Dermatophyte fungi',
        'Candida yeast',
        'Warm, moist conditions',
        'Tight, non-breathable clothing',
        'Weakened immune system',
        'Contact with infected individuals',
      ],
      symptoms: [
        'Red, scaly, circular patches (ringworm)',
        'Itching and burning',
        'Cracked, peeling skin',
        'White patches in skin folds',
        'Blisters or pustules',
        'Ring-shaped rash with clear center',
      ],
      recommendations:
          'Keep affected areas clean and dry. Use over-the-counter antifungal creams as directed. Wear loose, breathable clothing. Change socks and underwear daily. Do not share personal items like towels.',
      homeRemedies: [
        'Apply tea tree oil (diluted)',
        'Use apple cider vinegar soaks',
        'Apply coconut oil for mild cases',
        'Use garlic paste (with caution)',
        'Keep area dry with antifungal powder',
      ],
      whenToSeeDoctor:
          'See a doctor if infection does not improve with over-the-counter treatment after 2-4 weeks, spreads, or appears on the scalp or nails. Prescription antifungals may be needed.',
      requiresUrgentCare: false,
    ),
    'Urticaria (Hives)': const DiseaseGuidanceInfo(
      disease: 'Urticaria (Hives)',
      description:
          'Urticaria, or hives, are raised, itchy welts that can appear suddenly and may indicate an allergic reaction. They can occur anywhere on the body.',
      causes: [
        'Allergic reactions (food, medication)',
        'Insect stings',
        'Infections',
        'Temperature extremes',
        'Stress',
        'Unknown triggers (chronic urticaria)',
      ],
      symptoms: [
        'Raised, red or skin-colored welts',
        'Intense itching',
        'Welts that change shape and move',
        'Swelling (angioedema)',
        'Welts that blanch when pressed',
        'Episodes lasting hours to days',
      ],
      recommendations:
          'Identify and avoid triggers if known. Take antihistamines as directed. Apply cool compresses to soothe itching. Wear loose, comfortable clothing. Keep a diary to identify potential triggers.',
      homeRemedies: [
        'Apply cool compresses',
        'Take oatmeal baths',
        'Use calamine lotion',
        'Apply aloe vera gel',
        'Avoid hot showers',
      ],
      whenToSeeDoctor:
          'Seek EMERGENCY care if hives are accompanied by difficulty breathing, swelling of face/throat, dizziness, or rapid heartbeat (signs of anaphylaxis). See a doctor for persistent or recurring hives.',
      requiresUrgentCare: true,
    ),
    'Vascular Tumors': const DiseaseGuidanceInfo(
      disease: 'Vascular Tumors',
      description:
          'Vascular tumors are growths made of blood vessels, including hemangiomas and vascular malformations. Most are benign but some require monitoring or treatment.',
      causes: [
        'Abnormal blood vessel development',
        'Genetic factors',
        'Unknown causes for most',
        'May be present at birth',
        'Can develop with age',
        'Hormonal influences',
      ],
      symptoms: [
        'Red, purple, or blue skin marks',
        'Raised or flat lesions',
        'Soft, compressible masses',
        'May grow during childhood',
        'Can bleed if injured',
        'Usually painless',
      ],
      recommendations:
          'Have vascular lesions evaluated by a dermatologist. Most hemangiomas in infants resolve on their own. Larger or problematic lesions may require treatment. Protect from injury to prevent bleeding.',
      homeRemedies: [
        'Protect lesions from trauma',
        'Monitor for changes in size',
        'Keep area clean',
        'Apply gentle pressure if minor bleeding',
        'Take photos to track changes',
      ],
      whenToSeeDoctor:
          'See a doctor if the lesion grows rapidly, bleeds frequently, affects vision or breathing, or causes pain. Infants with large hemangiomas need monitoring.',
      requiresUrgentCare: false,
    ),
    'Vasculitis': const DiseaseGuidanceInfo(
      disease: 'Vasculitis',
      description:
          'Vasculitis refers to inflammation of blood vessels, which can affect the skin and other organs. It can cause skin rashes, ulcers, and other symptoms.',
      causes: [
        'Autoimmune disorders',
        'Infections',
        'Medications',
        'Cancers',
        'Immune system disorders',
        'Unknown causes',
      ],
      symptoms: [
        'Purple or red spots (purpura)',
        'Spots that do not blanch',
        'Skin ulcers',
        'Lumps under skin',
        'Numbness or weakness',
        'Fever and fatigue',
      ],
      recommendations:
          'SEEK MEDICAL EVALUATION promptly. Vasculitis can indicate serious underlying conditions and may affect internal organs. Treatment depends on the cause and severity.',
      homeRemedies: [
        'Rest and elevate affected limbs',
        'Apply warm compresses for comfort',
        'Keep skin clean and moisturized',
        'Avoid standing for long periods',
        'Eat an anti-inflammatory diet',
      ],
      whenToSeeDoctor:
          'See a doctor promptly if you notice purple spots that do not blanch when pressed, skin ulcers, or if you have systemic symptoms like fever, joint pain, or fatigue.',
      requiresUrgentCare: true,
    ),
    'Warts and Viral Infections': const DiseaseGuidanceInfo(
      disease: 'Warts and Viral Infections',
      description:
          'Warts are benign skin growths caused by human papillomavirus (HPV). Molluscum contagiosum is another common viral skin infection causing small, raised bumps.',
      causes: [
        'Human papillomavirus (HPV)',
        'Molluscum contagiosum virus',
        'Direct skin contact',
        'Weakened immune system',
        'Skin cuts or damage',
        'Shared surfaces and items',
      ],
      symptoms: [
        'Rough, grainy bumps (warts)',
        'Small, flesh-colored bumps',
        'Black pinpoints (clotted blood vessels)',
        'Clusters of bumps',
        'Bumps with dimpled center (molluscum)',
        'Usually painless',
      ],
      recommendations:
          'Many warts resolve on their own over months to years. Over-the-counter treatments containing salicylic acid can help. Do not pick or scratch warts as this can spread them. Keep warts covered.',
      homeRemedies: [
        'Apply salicylic acid treatment daily',
        'Use duct tape occlusion method',
        'Apply apple cider vinegar (with caution)',
        'Keep warts covered',
        'Boost immune system with healthy lifestyle',
      ],
      whenToSeeDoctor:
          'See a doctor if warts are painful, spreading rapidly, on the face or genitals, or if home treatments are not working after 2-3 months. People with weakened immunity should seek treatment.',
      requiresUrgentCare: false,
    ),
  };

  static const DiseaseGuidanceInfo _defaultGuidance = DiseaseGuidanceInfo(
    disease: 'Unknown Condition',
    description:
        'The detected condition could not be matched to our database. Please consult a healthcare professional for proper diagnosis.',
    causes: [
      'Various factors may contribute',
      'Professional evaluation recommended',
    ],
    symptoms: [
      'Symptoms may vary',
      'Please describe symptoms to your doctor',
    ],
    recommendations:
        'Please consult a healthcare professional for proper diagnosis and treatment recommendations. This AI analysis is not a substitute for medical advice.',
    homeRemedies: [
      'Keep skin clean and moisturized',
      'Avoid scratching or picking',
      'Monitor for changes',
      'Take photos to show your doctor',
    ],
    whenToSeeDoctor:
        'Consult a healthcare professional for any concerning skin condition, especially if it is painful, spreading, or not improving.',
    requiresUrgentCare: false,
  );
}

/// Guidance information for a specific disease
class DiseaseGuidanceInfo {
  final String disease;
  final String description;
  final List<String> causes;
  final List<String> symptoms;
  final String recommendations;
  final List<String> homeRemedies;
  final String whenToSeeDoctor;
  final bool requiresUrgentCare;

  const DiseaseGuidanceInfo({
    required this.disease,
    required this.description,
    required this.causes,
    required this.symptoms,
    required this.recommendations,
    required this.homeRemedies,
    required this.whenToSeeDoctor,
    required this.requiresUrgentCare,
  });
}
