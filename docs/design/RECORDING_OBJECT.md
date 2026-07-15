# Savlaq Recording Object

## Definition

A Recording is one `.wav` file plus all metadata, annotations, measurements, and QC information associated with that file.

## Core fields

recording_file  
recording_id  
speaker_id  
speaker_sex  
voice_profile  
source  
language  
stimulus_id  

## Linked files

audio_path  
textgrid_path  
speech_interval_csv_path  
measurement_csv_path  

## Stimulus metadata

word  
carrier_sentence  
lexical_category  
frequency  
frequency_rank  
syllable_count  
vowel_pattern  

## Annotation fields

recording_interval  
citation_interval  
sentence_interval  
word_intervals  
vowel_intervals  

## Measurement fields

duration  
mean_f0  
min_f0  
max_f0  
mean_intensity  
f1  
f2  

## QC fields

qc_status  
qc_flag  
qc_notes