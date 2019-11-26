import("delays.lib");

M = checkbox("en boucle");
V = 5;                   // Nombre de voix
B = checkbox("capture"); // Capture sound while pressed
R = (B-B') <= 0;		 // Reset capture when button is pressed
D = (+(B):*(R))~_;		 // Compute capture duration while button is pressed: 0..NNNN0..MMM

capture = _<:par(i, V, vgroup("boucle%i", *(B) : ((+ : delay(1048576, D-1)) ~ (*(M):*(1-B)))));

process = capture:>_;
