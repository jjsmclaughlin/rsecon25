from transformers import AutoTokenizer, AutoModelForCausalLM, pipeline
import torch

# Load tokenizer and model
model_id = "microsoft/phi-2"

print("Loading tokenizer...")
tokenizer = AutoTokenizer.from_pretrained(model_id)

print("Loading model (this may take a minute)...")
model = AutoModelForCausalLM.from_pretrained(
    model_id,
    torch_dtype=torch.float16,  # Needed to fit in 6GB GPU
    device_map="auto"           # Automatically use GPU if available
)

# Build text generation pipeline
generator = pipeline("text-generation", model=model, tokenizer=tokenizer)

# Prompt to test
#prompt = (
#    "Extract structured information from the following legal case text. "
#    "For each defendant, output one line in the format: [Defendant Name], [Crime Description], [Verdict]. "
#    "Text: Mary Cockshead and Mary Trigger, were indicted, the former for stealing 6 pair of Sheets, "
#    "the Goods of the Parishioners of St. Giles's Cripplegate and the latter for receiving the same "
#    "knowing them to be stoln, April 19. Guilty. [Transportation. See summary.]"
#)

#prompt = (
#    "Extract structured information from the following legal case text. "
#    "For each defendant, output one line in the format: [Defendant Name], [Verdict]. "
#    "Text: 57. Delina Poole otherwise Totley, was indicted for stealing a Cotton-Gown, two Shirts, a silk "
#    "Petticoat and a Linnen Handkerchief, the Goods of Daniel Smith, May 20. And 58. Ester Wyat, for "
#    "feloniously receiving two Shirts, a Handkerchief and the Petticoat, knowing them to be stole. Pool Guilty 10 d. Wyat, Acquitted."
#)

#prompt = (
#    "Extract structured information from the following legal case text."
#    "For each defendant, output one line in the following format: [Defendant Name], [Verdict]. "
#    "Use only the facts stated in the text.\n\n"
#    "Text to analyze:\n\n"
#    "\""
#    "George Butterfield, Edward Mould and Elizabeth Cook, of St. Ann's Westminster, were indicted for feloniously stealing 27 Saws the Property of several Persons, viz. 2 of John White 's, 5 of William Keys, 4 of William Anderson 's, 6 of Robert Raper 's, 6 of Anthony Sampson 's, and 5 of James Brody 's, the 20th of September last. To which Indictment George Butterfield pleaded Guilty ; but there not being sufficient Evidence against the two others, they were acquitted. [Transportation. See summary.]"
#    "\""
#)

#prompt = (
#    "You are an expert Natural Langugae Processing system. Your task is to extract structured information from the following legal case text. "
#    "For each defendant, output one line in the following format: [Defendant Name], [Verdict]. Do not put any other text in your answer. "
#    "Use only the facts stated in the text. \n\n"
#    "Text to analyze: \n\n"
#    "\""
#    "71, 72. Sarah Clark , otherwise West, and Elizabeth Thompson, were indicted for stealing a Gown, value 30 s. the Goods of Samuel Harris, October 21. Clark, Guilty, 10 d. Thompson, Acquitted. [Transportation. See summary.]"
#    "\""
#)

#prompt = (
#    "You are an expert Natural Langugae Processing system. Your task is to extract structured information from the following legal case text. "
#    "For each defendant, output one line in the following format: [Defendant Name], [Verdict]. Do not put any other text in your answer. "
#    "Use only the facts stated in the text. \n\n"
#    "Text to analyze: \n\n"
#    "\""
#    "82. 83. Thomas Rawlinson, and James Lawless, were indicted for stealing 50 lb. of Hempen Sacks, value 18 d. the Goods of William Williams, Dec . 21. Rawlinson Acquitted ; Lawless Guilty."
#    "\""
#)

#prompt = (
#    "You are an expert Natural Language Processing system. Your task is to extract structured information from the following legal case text. "
#    "For each defendant, output one line in the following format: [Defendant Name], [Verdict]. Do not put any other text in your answer. \n\n"
#    "Text to analyze: \n\n"
#    "\""
#    "21, 22. Robert Head and John Marsh were indicted for stealing 2 Shirts, the Goods of Richard Tireman, 3 Aprons, and a Handkerchief, the Goods of Elizabeth Hide, the 28th of April last. The Jury acquitted Marsh, and found Head Guilty to the Value of 10 d. [Transportation. See summary.]"
#    "\""
#)

prompt = (
    "Instruct: You are an expert Natural Language Processing system. Your task is to extract structured information from the following legal case text. "
    "For each defendant, output one line in the following format: [Defendant Name], [Verdict]. Do not put any other text in your answer. "
    "Text to analyze: "
    "\""
    "Robert Nowland, of Christ-Church, was indicted, and Patrick Nowland (his Father) of the same Parish, was a 2d time indicted for breaking and entering the House of William Durant. At the Prisoner Patrick's House. It appear'd that Trevors was a most notorious Rogue, and belong'd to Patrick's Gang; and that last Sessions he was try'd for robbing the Dog Tavern in Newgate-street, when Patrick was an Evidence for him. The Evidence not being sufficient against Robert Nowland, the Jury acquitted him, and found Patrick Guilty. Death."
    "\"\nOutput:"
)

# Generate output
print("\nGenerating...")
output = generator(prompt, max_new_tokens=256, temperature=0.1, do_sample=True)

# Display result
print("\n--- Output ---")
print(output[0]["generated_text"])
