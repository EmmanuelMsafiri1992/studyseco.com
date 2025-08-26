<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;

class SubjectDetailController extends Controller
{
    public function show($subjectId)
    {
        // Define detailed subject information
        $subjects = [
            1 => [
                'id' => 1,
                'name' => 'English Language',
                'description' => 'Master communication, literature, and composition skills',
                'icon' => '📚',
                'type' => 'core',
                'price' => 50000,
                'duration' => '4 Forms (1-4)',
                'difficulty' => 'Intermediate',
                'students_enrolled' => 1245,
                'completion_rate' => 96,
                'average_grade' => 'B+',
                'hero_image' => '/images/subjects/english-hero.jpg',
                'detailed_description' => 'English Language at StudySeco provides comprehensive training in communication, critical thinking, and literary analysis. Our MANEB-aligned curriculum ensures students develop strong reading, writing, speaking, and listening skills essential for academic success and professional development.',
                'why_choose' => [
                    'Master both written and spoken English to international standards',
                    'Develop critical thinking through literature analysis and creative writing',
                    'Build confidence in public speaking and presentations',
                    'Prepare thoroughly for MSCE examinations with proven success rates',
                    'Access to extensive digital library of classic and contemporary literature'
                ],
                'curriculum_highlights' => [
                    'Form 1-2: Foundation grammar, vocabulary building, basic composition',
                    'Form 3-4: Advanced literature, creative writing, critical analysis, MSCE preparation',
                    'Speaking & Listening: Debates, presentations, oral examinations',
                    'Literature: Malawian authors, African literature, world classics'
                ],
                'resources' => [
                    [
                        'title' => 'Interactive Digital Library',
                        'description' => 'Access 500+ books, poems, and plays with audio narrations',
                        'icon' => '📖'
                    ],
                    [
                        'title' => 'Writing Workshop Tools',
                        'description' => 'Grammar checker, essay templates, and peer review system',
                        'icon' => '✍️'
                    ],
                    [
                        'title' => 'Speaking Practice Lab',
                        'description' => 'Voice recording tools and pronunciation guides',
                        'icon' => '🎤'
                    ],
                    [
                        'title' => 'Past Examination Papers',
                        'description' => '10+ years of MSCE papers with detailed marking schemes',
                        'icon' => '📋'
                    ]
                ],
                'student_interactions' => [
                    'Weekly discussion forums on current literature',
                    'Peer review sessions for essay writing',
                    'Monthly poetry competitions and creative challenges',
                    'Live Q&A sessions with experienced teachers',
                    'Study groups organized by form level'
                ],
                'career_paths' => [
                    'Journalism & Media', 'Teaching & Education', 'Law & Legal Studies',
                    'Business & Communications', 'Creative Writing', 'Public Relations'
                ],
                'teacher_profile' => [
                    'name' => 'Mrs. Grace Nyasulu',
                    'qualification' => 'MA English Literature, University of Malawi',
                    'experience' => '15 years teaching secondary English',
                    'specialty' => 'Malawian Literature and Creative Writing'
                ]
            ],
            2 => [
                'id' => 2,
                'name' => 'Mathematics',
                'description' => 'Build strong foundations in algebra, geometry, and problem-solving',
                'icon' => '📐',
                'type' => 'core',
                'price' => 50000,
                'duration' => '4 Forms (1-4)',
                'difficulty' => 'Intermediate to Advanced',
                'students_enrolled' => 1180,
                'completion_rate' => 94,
                'average_grade' => 'B',
                'hero_image' => '/images/subjects/math-hero.jpg',
                'detailed_description' => 'Mathematics at StudySeco develops logical thinking, problem-solving skills, and mathematical reasoning essential for scientific and technical careers. Our comprehensive curriculum covers pure mathematics, statistics, and practical applications.',
                'why_choose' => [
                    'Build strong foundation in mathematical concepts and problem-solving',
                    'Develop logical thinking and analytical skills valued by employers',
                    'Access interactive tools and visual learning aids',
                    'Receive personalized feedback on problem-solving techniques',
                    'Prepare for advanced mathematics and science subjects'
                ],
                'curriculum_highlights' => [
                    'Form 1-2: Arithmetic, basic algebra, geometry fundamentals, fractions',
                    'Form 3-4: Advanced algebra, trigonometry, statistics, MSCE preparation',
                    'Problem Solving: Real-world applications, mathematical modeling',
                    'Technology: Calculator skills, graphing, data analysis'
                ],
                'resources' => [
                    [
                        'title' => 'Interactive Problem Solver',
                        'description' => 'Step-by-step solutions with visual explanations',
                        'icon' => '🧮'
                    ],
                    [
                        'title' => 'Graphing Tools',
                        'description' => 'Digital graphing calculator and function plotter',
                        'icon' => '📊'
                    ],
                    [
                        'title' => 'Practice Question Bank',
                        'description' => '1000+ problems organized by topic and difficulty',
                        'icon' => '📝'
                    ],
                    [
                        'title' => 'Video Tutorials',
                        'description' => 'Concept explanations and worked examples',
                        'icon' => '🎥'
                    ]
                ],
                'student_interactions' => [
                    'Daily problem-solving challenges and competitions',
                    'Peer tutoring sessions for difficult concepts',
                    'Mathematics club activities and projects',
                    'Regular assessment and progress tracking',
                    'Group work on real-world mathematical applications'
                ],
                'career_paths' => [
                    'Engineering', 'Computer Science', 'Finance & Banking',
                    'Data Science', 'Architecture', 'Economics'
                ],
                'teacher_profile' => [
                    'name' => 'Mr. Patrick Mbewe',
                    'qualification' => 'BSc Mathematics, Chancellor College',
                    'experience' => '12 years secondary mathematics teaching',
                    'specialty' => 'Applied Mathematics and Statistics'
                ]
            ],
            3 => [
                'id' => 3,
                'name' => 'Physical Science',
                'description' => 'Explore physics and chemistry fundamentals',
                'icon' => '⚗️',
                'type' => 'core',
                'price' => 50000,
                'duration' => '4 Forms (1-4)',
                'difficulty' => 'Advanced',
                'students_enrolled' => 890,
                'completion_rate' => 92,
                'average_grade' => 'B',
                'detailed_description' => 'Physical Science combines physics and chemistry to provide a comprehensive understanding of the natural world. Students develop scientific thinking, experimental skills, and mathematical problem-solving abilities essential for STEM careers.',
                'why_choose' => [
                    'Build strong foundation for advanced science subjects',
                    'Develop laboratory skills and scientific methodology',
                    'Understand the physical and chemical world around us',
                    'Prepare for careers in medicine, engineering, and research',
                    'Access virtual laboratory experiments and simulations'
                ],
                'curriculum_highlights' => [
                    'Form 1-2: Basic chemistry concepts, simple physics, measurement, atomic structure',
                    'Form 3-4: Advanced chemistry, mechanics, electricity, organic chemistry, MSCE prep',
                    'Laboratory Work: Hands-on experiments, data collection, analysis',
                    'Applications: Real-world applications in technology and industry'
                ],
                'resources' => [
                    [
                        'title' => 'Virtual Laboratory',
                        'description' => 'Conduct experiments safely with realistic simulations',
                        'icon' => '🧪'
                    ],
                    [
                        'title' => 'Formula Reference Bank',
                        'description' => 'Comprehensive collection of physics and chemistry formulas',
                        'icon' => '📝'
                    ],
                    [
                        'title' => 'Interactive Periodic Table',
                        'description' => 'Explore elements with properties and reactions',
                        'icon' => '⚛️'
                    ],
                    [
                        'title' => 'Practical Guides',
                        'description' => 'Step-by-step laboratory procedure videos',
                        'icon' => '🎬'
                    ]
                ],
                'student_interactions' => [
                    'Virtual lab sessions with peer collaboration',
                    'Science fair projects and competitions',
                    'Weekly problem-solving workshops',
                    'Chemistry and physics club activities',
                    'Research project presentations'
                ],
                'career_paths' => [
                    'Medicine & Healthcare', 'Chemical Engineering', 'Environmental Science',
                    'Research & Development', 'Pharmacy', 'Materials Science'
                ],
                'teacher_profile' => [
                    'name' => 'Dr. Kondwani Chirwa',
                    'qualification' => 'PhD Chemistry, University of the Witwatersrand',
                    'experience' => '18 years science education and research',
                    'specialty' => 'Analytical Chemistry and Physics Applications'
                ]
            ],
            4 => [
                'id' => 4,
                'name' => 'Social Studies',
                'description' => 'Understand history, geography, civics, and current affairs',
                'icon' => '🌍',
                'type' => 'core',
                'price' => 50000,
                'duration' => '4 Forms (1-4)',
                'difficulty' => 'Intermediate',
                'students_enrolled' => 1150,
                'completion_rate' => 95,
                'average_grade' => 'B+',
                'detailed_description' => 'Social Studies provides comprehensive understanding of Malawian society, African heritage, and global citizenship. Students develop critical thinking about social issues, historical events, and geographic patterns.',
                'why_choose' => [
                    'Understand Malawian history and cultural heritage',
                    'Develop critical thinking about social and political issues',
                    'Learn about global interconnectedness and citizenship',
                    'Prepare for careers in law, politics, and social services',
                    'Access rich multimedia content and historical archives'
                ],
                'curriculum_highlights' => [
                    'Form 1-2: Malawian history, basic geography, civics introduction',
                    'Form 3-4: African history, world geography, government systems, MSCE preparation',
                    'Current Affairs: Contemporary issues analysis and discussion',
                    'Projects: Research on local communities and global issues'
                ],
                'resources' => [
                    [
                        'title' => 'Digital History Archive',
                        'description' => 'Primary sources, photographs, and historical documents',
                        'icon' => '📚'
                    ],
                    [
                        'title' => 'Interactive Maps',
                        'description' => 'Explore Malawi and world geography dynamically',
                        'icon' => '🗺️'
                    ],
                    [
                        'title' => 'Current Affairs Hub',
                        'description' => 'Weekly news analysis and discussion materials',
                        'icon' => '📰'
                    ],
                    [
                        'title' => 'Documentary Collection',
                        'description' => 'Historical and geographical documentaries',
                        'icon' => '🎥'
                    ]
                ],
                'student_interactions' => [
                    'Weekly current affairs debates and discussions',
                    'Historical research project collaborations',
                    'Model United Nations participation',
                    'Community service learning projects',
                    'Cultural heritage preservation activities'
                ],
                'career_paths' => [
                    'Law & Legal Studies', 'Government & Politics', 'Social Work',
                    'International Relations', 'Journalism', 'Teaching'
                ],
                'teacher_profile' => [
                    'name' => 'Mr. Limbani Kachala',
                    'qualification' => 'MA History, University of Malawi',
                    'experience' => '14 years teaching Social Studies',
                    'specialty' => 'Malawian History and Civic Education'
                ]
            ],
            5 => [
                'id' => 5,
                'name' => 'Computer Studies',
                'description' => 'Master programming, hardware, and software applications',
                'icon' => '💻',
                'type' => 'core',
                'price' => 50000,
                'duration' => '4 Forms (1-4)',
                'difficulty' => 'Intermediate to Advanced',
                'students_enrolled' => 1320,
                'completion_rate' => 93,
                'average_grade' => 'A-',
                'detailed_description' => 'Computer Studies prepares students for the digital age with comprehensive coverage of computer systems, programming, and digital literacy. Essential skills for modern careers in any field.',
                'why_choose' => [
                    'Develop essential digital literacy skills for the 21st century',
                    'Learn programming fundamentals and computational thinking',
                    'Understand computer hardware and network systems',
                    'Prepare for high-demand technology careers',
                    'Access cloud-based development environments and tools'
                ],
                'curriculum_highlights' => [
                    'Form 1-2: Computer basics, MS Office, internet safety, simple programming',
                    'Form 3-4: Advanced programming, databases, networks, web development, MSCE prep',
                    'Programming: Python, HTML/CSS, JavaScript fundamentals',
                    'Projects: Real-world application development and problem-solving'
                ],
                'resources' => [
                    [
                        'title' => 'Online Code Editor',
                        'description' => 'Practice programming with instant feedback',
                        'icon' => '💾'
                    ],
                    [
                        'title' => 'Project Gallery',
                        'description' => 'Showcase and learn from student projects',
                        'icon' => '🖼️'
                    ],
                    [
                        'title' => 'Hardware Simulators',
                        'description' => 'Understand computer systems virtually',
                        'icon' => '🔧'
                    ],
                    [
                        'title' => 'Coding Challenges',
                        'description' => 'Daily programming problems and competitions',
                        'icon' => '🏆'
                    ]
                ],
                'student_interactions' => [
                    'Coding competitions and hackathons',
                    'Collaborative software development projects',
                    'Technology club meetings and presentations',
                    'Peer code review sessions',
                    'Industry guest speaker sessions'
                ],
                'career_paths' => [
                    'Software Development', 'Web Design', 'IT Support',
                    'Cybersecurity', 'Data Analysis', 'Digital Marketing'
                ],
                'teacher_profile' => [
                    'name' => 'Ms. Chisomo Mvula',
                    'qualification' => 'BSc Computer Science, UNIMA',
                    'experience' => '10 years programming and education',
                    'specialty' => 'Web Development and Database Systems'
                ]
            ],
            6 => [
                'id' => 6,
                'name' => 'Creative Arts',
                'description' => 'Express yourself through visual arts, music, drama, and creativity',
                'icon' => '🎨',
                'type' => 'core',
                'price' => 50000,
                'duration' => '4 Forms (1-4)',
                'difficulty' => 'Beginner to Intermediate',
                'students_enrolled' => 780,
                'completion_rate' => 97,
                'average_grade' => 'A',
                'detailed_description' => 'Creative Arts nurtures artistic expression and cultural appreciation through visual arts, music, drama, and creative writing. Students develop creativity, cultural understanding, and artistic skills.',
                'why_choose' => [
                    'Express creativity and develop artistic talents',
                    'Appreciate Malawian and global cultural heritage',
                    'Build confidence through performance and exhibition',
                    'Develop skills valuable in creative industries',
                    'Access digital art tools and music production software'
                ],
                'curriculum_highlights' => [
                    'Form 1-2: Basic drawing, painting, music theory, drama fundamentals',
                    'Form 3-4: Advanced techniques, cultural studies, performance, portfolio development',
                    'Traditional Arts: Malawian traditional music, dance, and crafts',
                    'Digital Arts: Computer graphics, digital music, video production'
                ],
                'resources' => [
                    [
                        'title' => 'Digital Art Studio',
                        'description' => 'Professional design and illustration software',
                        'icon' => '🖌️'
                    ],
                    [
                        'title' => 'Music Production Lab',
                        'description' => 'Record and compose music digitally',
                        'icon' => '🎵'
                    ],
                    [
                        'title' => 'Portfolio Platform',
                        'description' => 'Showcase your artistic creations online',
                        'icon' => '🖼️'
                    ],
                    [
                        'title' => 'Cultural Archive',
                        'description' => 'Explore Malawian traditional arts and culture',
                        'icon' => '🏛️'
                    ]
                ],
                'student_interactions' => [
                    'Monthly art exhibitions and showcases',
                    'Collaborative music and drama productions',
                    'Cultural festivals and celebrations',
                    'Peer critiques and artistic feedback sessions',
                    'Community art service projects'
                ],
                'career_paths' => [
                    'Graphic Design', 'Music Production', 'Fine Arts',
                    'Creative Writing', 'Arts Education', 'Cultural Preservation'
                ],
                'teacher_profile' => [
                    'name' => 'Mrs. Temwa Gondwe',
                    'qualification' => 'BA Fine Arts, University of Cape Town',
                    'experience' => '16 years arts education and practice',
                    'specialty' => 'Traditional Malawian Arts and Digital Media'
                ]
            ]
        ];

        // Get the subject or return 404
        if (!isset($subjects[$subjectId])) {
            abort(404, 'Subject not found');
        }

        $subject = $subjects[$subjectId];

        // Add some dynamic stats
        $subject['success_stories'] = [
            [
                'name' => 'Chisomo Banda',
                'achievement' => 'Scored A in MSCE, now studying at University of Cape Town',
                'quote' => 'StudySeco\'s ' . $subject['name'] . ' course gave me the confidence and knowledge I needed to excel.'
            ],
            [
                'name' => 'James Phiri',
                'achievement' => 'Improved from D to B+ in one year',
                'quote' => 'The interactive resources and teacher support made all the difference in my understanding.'
            ]
        ];

        return Inertia::render('SubjectDetail', [
            'subject' => $subject,
            'relatedSubjects' => array_slice($subjects, 0, 3, true), // Show first 3 as related
            'canEnroll' => true
        ]);
    }
}
