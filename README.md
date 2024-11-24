# quality_decomposition

Code used on scanner data for 10 NZ consumer electronics products to produce results.

Also, all the results underpinning the plots in the paper (plus various descriptive measures) - all for adjacent periods within the 9 quarter window of data

Input data is called 'alldata' and is a list of 10 R dataframes corresponding to the 10 products.  The required variables to run the analysis are:
- period, Date format e.g. "2021-06-01"
- price, num format
- volume, num format
- value, num format
- id, Factor format

Price is the average price, volume is the quality sold, value is the total expenditure.  There should be only one record per id per quarter for each product.
